Rem Attribute VBA_ModuleType=VBAClassModule
Option VBASupport 1
Option ClassModule
' ---
' Name: cStringBuilder
' Type: Script
' Use: >
'   VBA string builder class. The StringBuilder class is
'   designed to incrementally build up strings using an
'   internal buffer to prevent unnecessary string copying.
'   This class is typically used to perform multiple 
'   concatenations in a row without paying the cost of the 
'   subpar & operator (That will create a new variable each 
'   Time) and abuse the faster Mid$() function. This saved 
'   minutes on my first corporate coding assignment
' Tags: !!str "#stringbuilder #buffer #array"
' Creation: 2012-06-09
' Update: 2026-06-18
' Contributors: [神縁]
' Version: !!str 1.1.1
' ---

'= Imports: Null 

'Option Compare Database
Option Explicit
Option Base 1


'===============================================================================
'=# 0. Local Variables                                                       ===
'===============================================================================

Private m_sBuffer As String '// The buffer
Private m_lBufferLength As Long '// Length of the string value within the buffer
Private m_lBufferSize As Long '// Length of the buffer
Private m_lInitialSize As Long '// Initial Length of the buffer

Private Const m_lBUF_INITIAL_LENGTH As Long = 32


'===============================================================================
'=# 1. Constructors & Destructors                                            ===
'===============================================================================

Private Sub Class_Initialize()
    '// We set the buffer up to it's initial size and the string value ""
    m_lInitialSize = m_lBUF_INITIAL_LENGTH
    m_lBufferSize = m_lInitialSize
    m_sBuffer = Space$(m_lBufferSize)
    m_lBufferLength = 0
End Sub


'===============================================================================
'=# 2. Properties Access                                                     ===
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
'=# 3. Public Functions & Subs                                               ===
'===============================================================================

'=-----------------------
'= Name:        Append
'= Description: Appends text to the string.
'= Inputs:      i_sText => The text to append As String
'= History:     2012-06-09 - 神縁 - Creation
'=-----------------------
Public Sub Append(i_sText As String)
    Dim lTextLength As Long '// The length that the value will be increased by
    Dim lBufferLength As Long '//xc The length of the value after being appended
    
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

'=-----------------------
'= Name:        Clear
'= Description: Clears the content of the buffer.
'= Inputs:      [i_bCompactBuffer] => Remove the previous Buffer from
'=              memory.
'=              Used to free memory after a really huge string As Boolean
'= History:     2012-06-09 - 神縁 - Creation
'=              2012-06-09 - 神縁 - Added i_bCompactBuffer
'=-----------------------
Public Sub Clear(Optional i_bCompactBuffer As Boolean = True)
    If i_bCompactBuffer Then
        m_lBufferSize = m_lInitialSize
        m_sBuffer = Space$(m_lBufferSize)
    End If
    m_lBufferLength = 0
End Sub

'=-----------------------
'= Name:        Compact
'= Description: Reduce the memory used while retaining the text value.
'= History:     2012-07-04 - 神縁 - Creation
'=-----------------------
Public Sub Compact()
    Dim sTemp As String
    
    sTemp = Left$(m_sBuffer, m_lBufferLength)
    m_lBufferSize = m_NextPowerOf2(m_lBufferLength)
    m_sBuffer = Space$(m_lBufferSize)
    Mid$(m_sBuffer, 1, Len(sTemp)) = sTemp
End Sub

'=-----------------------
'= Name:        Insert
'= Description: Insert a string into the buffer at specific location.
'= Inputs:      i_sText => String to insert As String
'=              [i_lPosition] => Position where the new string will be
'=                               inserted (Start by default) As Long
'= Outputs:     Insert => Insert done properly As Boolean
'= History:     2012-07-03 - 神縁 - Creation
'=              2012-07-04 - 神縁 - Reworked for FindText
'=              compatibility.
'=-----------------------
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

'=-----------------------
'= Name:        Remove
'= Description: Remove a portion of the buffer
'= Inputs:      i_lPosition => Start of the portion to remove As Long
'=              i_lSize => Size of the portion to remove As Long
'= History:     2012-07-03 - 神縁 - Creation
'=              2012-07-04 - 神縁 - Reworked for FindText
'=              compatibility.
'=-----------------------
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

'=-----------------------
'= Name:        FindText
'= Description: Returns the position of the specified text, or 0 if
'=              the text was not found.
'= Inputs:      i_sSearch => The text to search for.
'=              [i_lOccurence] => Search for the Nth occurence of the
'=              string As Long
'=              [i_eCompareMethod] => VBA Compare Method As
'=              VbCompareMethod
'= Outputs:     FindText As Long
'= History:     2012-07-04 - 神縁 - Creation
'=-----------------------
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

'=-----------------------
'= Name:        SubString
'= Description: Returns a substring from the buffer
'= Inputs:      i_lStartPosition => As Long
'=              [i_lSize] => As Long
'= Outputs:     SubString As String
'= History:     2012-07-04 - 神縁 - Creation
'=-----------------------
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

'=-----------------------
'= Name:        MultiReplace
'= Description: Replace on the buffer with multiple parameters.
'= Inputs:      i_vaFindReplace() => Couples Find/Replace As Variant
'= History:     2012-06-09 - 神縁 - Creation
'=-----------------------
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
'=# 4. Private Functions & Subs                                              ===
'===============================================================================

'=-----------------------
'= Name:        m_NextPowerOf2
'= Description: Round a number to the next Power of 2
'= Inputs:      i_lValue => As Long
'= Outputs:     m_NextPowerOf2 As Long
'= History:     2012-07-04 - 神縁 - Creation
'=              2026-06-18 - 神縁 - Deprecated the computational 
'=              version for an even faster bitwise comparison.
'=-----------------------
Private Function m_NextPowerOf2(i_vValue As Variant) As Variant
    Dim cValue As Currency '// Use Currency for 64-bit integer math

    '// Convert input to Currency (64-bit integer precision)
    On Error Resume Next
        If VarType(i_vValue) = vbLong Then
            cValue = CDec(i_vValue)
        ElseIf VarType(i_vValue) = vbLongLong Then
            cValue = CDec(i_vValue)
        Else
            Err.Raise vbObjectError + 999, "m_NextPowerOf2", "Input must be a Long or LongLong"
        End If
    On Error GoTo 0

    If cValue < 0 Then _
        Err.Raise vbObjectError + 999, "m_NextPowerOf2", "Input must be a positive integer."

    If cValue = 0 Then
        m_NextPowerOf2 = 1
        GoTo Exit_Procedure
    End If

    '// Handle the special case where input is already a power of 2
    If (cValue And (cValue - 1)) = 0 Then
        m_NextPowerOf2 = cValue
        GoTo Exit_Procedure
    End If

    '// Bitwise operations for next power of 2
    cValue = cValue - 1
    cValue = cValue Or (cValue \ 2)
    cValue = cValue Or (cValue \ 4)
    cValue = cValue Or (cValue \ 8)
    cValue = cValue Or (cValue \ 16)
    cValue = cValue Or (cValue \ 32)
    cValue = cValue Or (cValue \ 64)
    cValue = cValue Or (cValue \ 128)

    m_NextPowerOf2 = cValue + 1

Exit_Procedure:
End Function
'Private Function m_NextPowerOf2(i_lValue As Long) As Long
'    m_NextPowerOf2 = Round(Log(i_lValue) / Log(2))
'    m_NextPowerOf2 = 2 ^ m_NextPowerOf2
'    If m_NextPowerOf2 < i_lValue Then _
'        m_NextPowerOf2 = m_NextPowerOf2 * 2
'End Function


'===============================================================================
'=# 5. Event Management                                                      ===
'===============================================================================


'===============================================================================
'=# 6. Test Harnesses                                                        ===
'===============================================================================

Public Sub Test_m_NextPowerOf2()
    Dim vaTestCases As Variant
    Dim vResult As Variant
    Dim sResult As String
    Dim bHasPassed As Boolean
    Dim bFailure As Boolean: bFailure = False
    Dim lLBound As Long
    Dim lUBound As Long

    '// Comprehensive test cases including LongLong values
    vaTestCases = Array( _
        '// Error cases
        Array(-1, "Err"),           '// Negative input
        Array(-9223372036854775808, "Err"),  '// Minimum LongLong

        '// Zero edge case
        Array(0, 1),

        '// Power of 2 cases (Long range)
        Array(1, 1),            '// 2^0
        Array(2, 2),            '// 2^1
        Array(4, 4),            '// 2^2
        Array(16, 16),          '// 2^4
        Array(1024, 1024),      '// 2^10
        Array(32768, 32768),    '// 2^15
        Array(2147483648, 2147483648), '// 2^31

        '// Power of 2 cases (LongLong range)
        Array(9223372036854775808, 9223372036854775808), '// 2^63
        Array(4611686018427387904, 4611686018427387904), '// 2^62

        '// Non-power of 2 cases (Long range)
        Array(3, 4),            '// Between 2^1 and 2^2
        Array(5, 8),            '// Between 2^2 and 2^3
        Array(7, 8),            '// Just below 2^3
        Array(9, 16),           '// Between 2^3 and 2^4
        Array(15, 16),          '// Just below 2^4
        Array(17, 32),          '// Between 2^4 and 2^5
        Array(100, 128),        '// Arbitrary value
        Array(1000000, 1048576) '// Large value

        '// Non-power of 2 cases (LongLong range)
        Array(5000000000000000000, 5764607523034234880), '// Large LongLong
        Array(9223372036854775000, 9223372036854775808) '// Near max LongLong
    )

    '// Initialize bounds
    lLBound = LBound(vaTestCases)
    lUBound = UBound(vaTestCases)

    '// Run test cases
    For lLBound = LBound(vaTestCases) To UBound(vaTestCases)
        On Error Resume Next
            vResult = m_NextPowerOf2(vaTestCases(lLBound)(0))
            bHasPassed = (vResult = vaTestCases(lLBound)(1)) And (Err.Number = 0)
        On Error GoTo 0

        '// Format result string
        If Err.Number <> 0 Then
            sResult = "Err(" & Err.Number & ")"
            Err.Clear
        ElseIf vResult = 0 Then
            sResult = "Err(Silent)"
        Else
            sResult = CStr(vResult)
        End If

        '// Update failure flag
        bFailure = bFailure Or Not (bHasPassed)

        '// Print results
        Debug.Print "Input: " & vaTestCases(lLBound)(0) & _
                    " | Expected: " & vaTestCases(lLBound)(1) & _
                    " | Result: " & sResult & _
                    " | " & IIf(bHasPassed, "PASS", "FAIL")
    Next lLBound

    Debug.Print vbCrLf & "Test Summary:"
    Debug.Print "Total Tests: " & (lUBound - lLBound + 1)
    Debug.Print "Test Failure: " & bFailure
End Sub

'===============================================================================
'=# 7. Comments                                                              ===
'===============================================================================

'===============================================================================
'= History: 2012-06-09 - 神縁 - Creation
'=          2012-07-03 - 神縁 - Added New Methods and changed the Clear routine 
'=                             to use an already allocated buffer.
'=          2012-07-04 - 神縁 - Added Findtext, Compact and SubString Methods and 
'=                             reworked Insert. Also added some control over the 
'=                             initial size of the buffer.
'=          2026-06-18 - 神縁 - Added a new clever trick I learned today Bitwise 
'=                             comparison for Power of 2. Just to get my coding 
'=                             skills sharp.
'===============================================================================