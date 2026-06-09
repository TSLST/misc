Rem Attribute VBA_ModuleType=VBAClassModule
Option VBASupport 1
Option ClassModule
'===============================================================================
'= Name              : cStringBuilder
'= Description       : VBA string builder class. The StringBuilder class is
'=                     designed to incrementally build up strings using an
'=                     internal buffer to prevent unnecessary string copying.
'= References        :
'= History           : 2012-06-09 Laurent Villard: Creation
'=                     2012-07-03 Laurent Villard: Added New Methods and changed
'=                                the Clear routine to use an already allocated
'=                                buffer.
'=                     2012-07-04 Laurent Villard: Added Findtext, Compact and
'=                                SubString Methods and reworked Insert. Also
'=                                added some control over the initial size of
'=                                the buffer.
'===============================================================================

'Option Compare Database
Option Explicit
Option Base 1


'===============================================================================
'=== 0. Local Variables                                                      ===
'===============================================================================

Private m_sBuffer As String '// The buffer
Private m_lBufferLength As Long '// Length of the string value within the buffer
Private m_lBufferSize As Long '// Length of the buffer
Private m_lInitialSize As Long '// Initial Length of the buffer

Private Const m_lBUF_INITIAL_LENGTH As Long = 32


'===============================================================================
'=== 1. Constructors & Destructors                                           ===
'===============================================================================

Private Sub Class_Initialize()
    '// We set the buffer up to it's initial size and the string value ""
    m_lInitialSize = m_lBUF_INITIAL_LENGTH
    m_lBufferSize = m_lInitialSize
    m_sBuffer = Space$(m_lBufferSize)
    m_lBufferLength = 0
End Sub


'===============================================================================
'=== 2. Properties Access                                                    ===
'===============================================================================

Public Property Get Length() As Long
    Length = m_lBufferLength
End Property

Public Property Get Text() As String
    Text = Left$(m_sBuffer, m_lBufferLength)
End Property
Public Property Let Text(i_sText As String)
    Call Me.Clear(False)
    Call Me.Append(i_sText)
End Property

Public Property Get InitialSize() As Long
    InitialSize = m_lInitialSize
End Property
Public Property Let InitialSize(i_lInitialSize As Long)
    m_lInitialSize = m_NextPowerOf2(i_lInitialSize)
End Property


'===============================================================================
'=== 3. Public Functions & Subs                                              ===
'===============================================================================

'=-------------------------------------------------
'= Name              : Append
'= Description       : Appends text to the string.
'= Inputs            : i_sText => The text to append As String
'= History           : 2012-06-09 Laurent Villard: Creation
'=-------------------------------------------------
Public Sub Append(i_sText As String)
    Dim lTextLength As Long '// The length that the value will be increased by
    Dim lBufferLength As Long '// The length of the value after being appended
    
    lTextLength = Len(i_sText)
    If lTextLength = 0 Then _
        GoTo Exit_Procedure
    
    lBufferLength = m_lBufferLength + lTextLength
    '// Check if the buffer is big enough to hold the data
    If m_lBufferSize < lBufferLength Then
        '// Resize the buffer
        Do While m_lBufferSize < lBufferLength
            m_lBufferSize = m_lBufferSize + m_lBufferSize
        Loop
        m_sBuffer = Left$(m_sBuffer, m_lBufferLength) & Space$(m_lBufferSize - m_lBufferLength)
    End If
    
    '// Insert the append string
    Mid$(m_sBuffer, m_lBufferLength + 1, lTextLength) = i_sText
    '// Store the new length
    m_lBufferLength = lBufferLength
    
Exit_Procedure:
End Sub

'=-------------------------------------------------
'= Name              : Clear
'= Description       : Clears the content of the buffer.
'= Inputs            :[i_bCompactBuffer] => Remove the previous Buffer from
'=                     memory.
'=                     Used to free memory after a really huge string As Boolean
'= History           : 2012-06-09 Laurent Villard: Creation
'=                     2012-06-09 Laurent Villard: Added i_bCompactBuffer
'=-------------------------------------------------
Public Sub Clear(Optional i_bCompactBuffer As Boolean = True)
    If i_bCompactBuffer Then
        m_lBufferSize = m_lInitialSize
        m_sBuffer = Space$(m_lBufferSize)
    End If
    m_lBufferLength = 0
End Sub

'=-------------------------------------------------
'= Name              : Compact
'= Description       : Reduce the memory used while retaining the text value.
'= History           : 2012-07-04 Laurent Villard: Creation
'=-------------------------------------------------
Public Sub Compact()
    Dim sTemp As String
    
    sTemp = Left$(m_sBuffer, m_lBufferLength)
    m_lBufferSize = m_NextPowerOf2(m_lBufferLength)
    m_sBuffer = Space$(m_lBufferSize)
    Mid$(m_sBuffer, 1, Len(sTemp)) = sTemp
End Sub

'=-------------------------------------------------
'= Name              : Insert
'= Description       : Insert a string into the buffer at specific location.
'= Inputs            : i_sText => String to insert As String
'=                    [i_lPosition] => Position where the new string will be
'=                                     inserted (Start by default). As Long
'= Outputs           : Insert => Insert done properly As Boolean
'= History           : 2012-07-03 Laurent Villard: Creation
'=                     2012-07-04 Laurent Villard: Reworked for FindText
'=                     compatibility.
'=-------------------------------------------------
Public Sub Insert(i_sText As String, Optional i_lPosition As Long = 1)
    Dim lTextLength As Long '// The length that the value will be increased by
    Dim lBufferLength As Long '// The length of the value after being appended
    
    lTextLength = Len(i_sText)
    If lTextLength = 0 Then _
        GoTo Exit_Procedure
    
    If i_lPosition < 1 Or i_lPosition > m_lBufferLength + 1 Then _
        GoTo Exit_Procedure
    If i_lPosition > m_lBufferLength Then
        Me.Append i_sText
        GoTo Exit_Procedure
    End If
    
    lBufferLength = m_lBufferLength + lTextLength
    '// Check if the buffer is big enough to hold the data
    If m_lBufferSize < lBufferLength Then
        '// Resize the buffer
        Do While m_lBufferSize < lBufferLength
            m_lBufferSize = m_lBufferSize + m_lBufferSize
        Loop
        m_sBuffer = Left$(m_sBuffer, m_lBufferLength) & Space$(m_lBufferSize - m_lBufferLength)
    End If
    
    '// Move the ending string
    Mid$(m_sBuffer, i_lPosition + lTextLength, m_lBufferLength - i_lPosition + 1) = Mid$(m_sBuffer, i_lPosition, m_lBufferLength - i_lPosition + 1)
    '// Insert the new string
    Mid$(m_sBuffer, i_lPosition, lTextLength) = i_sText
    '// Store the new length
    m_lBufferLength = lBufferLength
Exit_Procedure:
End Sub

'=-------------------------------------------------
'= Name              : Remove
'= Description       : Remove a portion of the buffer
'= Inputs            : i_lPosition => Start of the portion to remove As Long
'=                     i_lSize => Size of the portion to remove As Long
'= History           : 2012-07-03 Laurent Villard: Creation
'=                     2012-07-04 Laurent Villard: Reworked for FindText
'=                     compatibility.
'=-------------------------------------------------
Public Sub Remove(i_lPosition As Long, ByVal i_lSize As Long)
    If i_lPosition < 1 Or i_lPosition > m_lBufferLength Then _
        GoTo Exit_Procedure
    If i_lPosition + i_lSize > m_lBufferLength Then _
        i_lSize = m_lBufferLength - i_lPosition + 1
    
    '// Move the ending string
    Mid$(m_sBuffer, i_lPosition, m_lBufferLength - i_lPosition - i_lSize + 1) = Mid$(m_sBuffer, i_lPosition + i_lSize, m_lBufferLength - i_lPosition - i_lSize + 1)
    '// Store the new length
    m_lBufferLength = m_lBufferLength - i_lSize
Exit_Procedure:
End Sub

'=-------------------------------------------------
'= Name              : FindText
'= Description       : Returns the position of the specified text, or 0 if
'=                     the text was not found.
'= Inputs            : i_sSearch => The text to search for.
'=                    [i_lOccurence] => Search for the Nth occurence of the
'=                     string As Long
'=                    [i_eCompareMethod] => VBA Compare Method As
'=                     VbCompareMethod
'= Outputs           : FindText As Long
'= History           : 2012-07-04 Laurent Villard: Creation
'=-------------------------------------------------
Public Function FindText(i_sSearch As String, Optional i_lOccurence As Long = 1, Optional i_eCompareMethod As VbCompareMethod = vbBinaryCompare) As Long: FindText = 0
    Dim lPosition As Long: lPosition = 0
    
    If m_lBufferLength = 0 Then _
        GoTo Exit_Procedure
    If i_lOccurence < 1 Then _
        GoTo Exit_Procedure
    
    '// Search for the string
    Do
        lPosition = InStr(lPosition + 1, m_sBuffer, i_sSearch, i_eCompareMethod)
        i_lOccurence = i_lOccurence - 1
    Loop Until lPosition = 0 Or i_lOccurence = 0
    FindText = lPosition
    If FindText + Len(i_sSearch) - 1 > m_lBufferLength Then
        '// Didn't find the string within the used buffer
        FindText = 0
    End If
    
Exit_Procedure:
End Function

'=-------------------------------------------------
'= Name              : SubString
'= Description       : Returns a substring from the buffer
'= Inputs            : i_lStartPosition => As Long
'=                    [i_lSize] => As Long
'= Outputs           : SubString As String
'= History           : 2012-07-04 Laurent Villard: Creation
'=-------------------------------------------------
Public Function SubString(i_lStartPosition As Long, Optional ByVal i_lSize As Long = -1) As String: SubString = ""
    If i_lStartPosition < 1 Or i_lStartPosition > m_lBufferLength Then _
        GoTo Exit_Procedure
    If i_lSize = 0 Then _
        GoTo Exit_Procedure
    
    If i_lSize = -1 Then _
        i_lSize = m_lBufferLength
    If i_lStartPosition + i_lSize > m_lBufferLength Then
        i_lSize = m_lBufferLength - i_lStartPosition + 1
    End If
    
    SubString = Mid$(m_sBuffer, i_lStartPosition, i_lSize)
    
Exit_Procedure:
End Function

'=-------------------------------------------------
'= Name              : MultiReplace
'= Description       : Replace on the buffer with multiple parameters.
'= Inputs            : i_vaFindReplace() => Couples Find/Replace As Variant
'= History           : 2012-06-09 Laurent Villard: Creation
'=-------------------------------------------------
Public Sub MultiReplace(ParamArray i_vaFindReplace() As Variant)
    Dim lI As Long
    Dim lCount As Long
    
    lCount = UBound(i_vaFindReplace) + 1
    If lCount Mod 2 > 0 Then _
        GoTo Exit_Procedure
    
    For lI = 1 To lCount Step 2
        m_sBuffer = Replace$(m_sBuffer, CStr(i_vaFindReplace(lI - 1)), CStr(i_vaFindReplace((lI - 1) + 1)))
    Next
    
Exit_Procedure:
End Sub


'===============================================================================
'=== 4. Private Functions & Subs                                             ===
'===============================================================================

'=-------------------------------------------------
'= Name              : m_NextPowerOf2
'= Description       : Round a number to the next Power of 2
'= Inputs            : i_lValue => As Long
'= Outputs           : m_NextPowerOf2 As Long
'= History           : 2012-07-04 Laurent Villard: Creation
'=-------------------------------------------------
Private Function m_NextPowerOf2(i_lValue As Long) As Long
    m_NextPowerOf2 = Round(Log(i_lValue) / Log(2))
    m_NextPowerOf2 = 2 ^ m_NextPowerOf2
    If m_NextPowerOf2 < i_lValue Then _
        m_NextPowerOf2 = m_NextPowerOf2 * 2
End Function


'===============================================================================
'=== 5. Event Management                                                     ===
'===============================================================================

