---
Type: PRD
Use: Developing a skil that would allow to process a pdf file.
Tags: !!str "#alexandria #pdf #math #ocr"
Creation: 2026-06-09
Update: 2026-06-09
Contributors: 神縁
Links: >
    [[alexandria]]
---

# Alexandria Processor Project

-----------------------------------------
## Objectives
-----------------------------------------

---
### Main Objective

Develop a python module that can transform a pdf with mathematical or text content into a properly formatted Markdown equivalent.

---
### Definition of Properly formatted

___
#### Issue I: Linebreaks

Long sentences and paragraphs are usually broken at line length rather than the intended breaks.
Also Markdown needs to enforce but not generalize the use of <br> tags to cut some lengthy paragraphs into preserved meaning.

##### Solutions

- Use PDF layout analysis (e.g. pdfplumber, PyMuPDF) to detect line breaks caused by page margins vs. intentional breaks.
- Heuristics: If a line ends with a hyphen or is followed by a line starting with a lowercase letter, it’s likely a soft break and should be merged.
- LLM Approach: Train/fine-tune a small model to detect semantic vs. soft breaks, or use prompt engineering with a general LLM to merge lines intelligently.

___
#### Issue II: Headings

Headings are losing their ordination in text extracts of PDF.
A title with police size 20 and standard text of police size 12 are usually read at the same basic level.
Solutions possible:
- Either use the pdf formatting code structure to extract heading levels
- Or use OCR de derive heading level from text size
- Or use the table of contents to spot the titles reapeated later on.

##### Solutions

- PDF Metadata: Use libraries like pdfplumber or pdfminer to extract font sizes, styles (bold/italic), and positions to infer heading levels.
- OCR + Layout: If the PDF is image-based, use OCR (e.g. pytesseract + OpenCV) to detect text size, position, and styling.
- Table of Contents (ToC): Cross-reference text with the ToC to identify headings. Tools like PyPDF2 can extract the ToC.
Hybrid Approach: Combine all three methods for robustness.

___
#### Issue III: Math Equations

Rendering of math equations is usually poor when transcribing a pdf file.
Math equations should be properly transformed into KaTeX code that represents valid mathematical concepts. E.G. rendering of 𝐹𝑛 = 1 √5 [(1 + √5 2 ) 𝑛 − (1 − √5 2 ) 𝑛 ] should be:
$\displaystyle
    𝐹_𝑛 = \frac{1} {\sqrt{5}} \times 
    \left[
        \left(
            \frac{1 + \sqrt{5}} {2} 
        \right)^𝑛
        − \left(
            \frac{1 − \sqrt{5}} {2} 
        \right)^𝑛
    \right]
$
the Binet's formula for the $n$-th Fibonacci number $F_n$.

Text reading tend to only read out characters and not formula structure, hence losing their relationship.

KaTeX is chose as the default math formatting although LLMs tend to use

##### Solutions

- LaTeX Extraction: Use tools like pymupdf or pdf2latex to extract LaTeX directly from PDFs (if available).
- OCR for Math: Use specialized OCR for math (e.g. Mathpix, InftyReader) to convert equation images to LaTeX.
- Post-Processing: Use regex or a small LLM to clean up OCR output and wrap it in $...$ or $$...$$ for KaTeX.
- Validation: Render the KaTeX output to verify correctness (e.g. using katex Python bindings).

___
#### Issue IV: Tables

Tables that cannot really be extracted as text (i.e. image tables) can be reinterpreted using markdown formating:
| Column 1  | Column 2      | Column 3      |
|---        |---            |---            |
| Line 1    | $bla_{12}$    | $bla_{12}$    |
| Line 2    | $bla_{12}$    | $bla_{12}$    |
| Line 3    | $bla_{12}$    | $bla_{12}$    |
by using OCR to derive structure.

##### Solutions

- PDF Table Extraction: Use camelot, tabula-py, or pdfplumber to extract tables as DataFrames, then convert to Markdown.
- OCR for Image Tables: Use pytesseract + OpenCV to detect table structures (lines, grids) and extract cell contents.
- LLM for Table Formatting: Feed raw table text to an LLM with instructions to format it as Markdown.

-----------------------------------------
## Proposed Pipeline
-----------------------------------------

1. **Input**: PDF file (or directory of PDFs).
2. **Preprocessing**:
   - Extract raw text and layout data from PDF.
   - Clean text (remove artifacts, normalize whitespace).
3. **Layout Analysis**:
   - Detect headings, paragraphs, lists, and tables.
4. **OCR (if needed)**:
   - For image-based PDFs or regions, extract text and math.
5. **Math Conversion**:
   - Convert detected math to KaTeX.
6. **Table Conversion**:
   - Convert detected tables to Markdown.
7. **Formatting**:
   - Apply line break, heading, and math formatting rules.
8. **Post-Processing**:
   - Validate and clean up the Markdown.
9. **Output**: Markdown file(s).

-----------------------------------------
## Phase 1
-----------------------------------------

For **Phase 1**, prioritize:
- **Core Formatter Function**: Handle line breaks, basic headings, and math wrapping.
- **OCR Function**: Extract text and math from PDFs (start with `pymupdf` + `pytesseract`).
- **Math Conversion**: Use regex + LLM to wrap math in KaTeX.
- **Table Extraction**: Use `camelot` for simple tables.

-----------------------------------------
## Tools and Libraries to Consider
-----------------------------------------

| Task                | Recommended Tools/Libraries          |
|---------------------|--------------------------------------|
| PDF Text Extraction | `pdfplumber`, `PyMuPDF`, `pdfminer`  |
| OCR                 | `pytesseract`, `Mathpix`, `InftyReader` |
| Math Conversion     | `latex2mathml`, `katex`, `sympy`     |
| Table Extraction    | `camelot`, `tabula-py`, `pdfplumber` |
| Layout Analysis     | `pdfplumber`, `OpenCV`               |
| LLM Integration     | `transformers`, `openai` API         |
| Validation          | `katex`, `IPython.display`           |

-----------------------------------------
## Potential Challenges
-----------------------------------------

1. **Math Accuracy**: OCR for math is error-prone. Consider using a hybrid approach (OCR + LLM correction).
2. **Layout Complexity**: Multi-column layouts or nested tables may require advanced logic.
3. **Performance**: OCR and LLM calls can be slow. Optimize with caching and batching.
4. **Edge Cases**: Footnotes, sidebars, or non-standard fonts may need special handling.

-----------------------------------------
## Next Steps for Planning
-----------------------------------------

1. **Define Scope for Phase 1**:
   - Start with text-heavy PDFs (no images) and simple math.
   - Use `pdfplumber` for text extraction and regex for math detection.
2. **Prototype the Formatter**:
   - Write pseudocode for the formatter function (line breaks, headings, math).
3. **Test with Sample PDFs**:
   - Gather 5-10 PDFs with varying complexity (e.g. a math textbook, a research paper).
4. **Iterate**:
   - Refine based on test results, then add OCR and table support.

-----------------------------------------
## Example Workflow for a Math PDF
-----------------------------------------

1. Extract text and layout with `pdfplumber`.
2. Detect headings by font size (e.g. size > 14 → heading).
3. Use regex to find math expressions (e.g. `F_n = ...`).
4. Wrap math in `$...$` and validate with `katex`.
5. Convert tables with `camelot` to Markdown.
6. Clean up line breaks and spacing.

-----------------------------------------
## Questions to Refine the Plan
-----------------------------------------

- Should the project support **image-only PDFs** from the start, or focus on text-based PDFs first?
- Do you want to **train a custom LLM** for formatting, or rely on existing APIs (e.g. OpenAI)?
- Should the output be **pure Markdown**, or include HTML/LaTeX for unsupported features?
- Are there **specific PDF types** (e.g. textbooks, papers) to prioritize?

-----------------------------------------
## Methods
-----------------------------------------

---
### Preprocessing Function

#### Purpose

Clean and normalize raw text before formatting.

#### Tasks

Remove artifacts (e.g. page numbers, headers/footers).
Normalize whitespace, hyphens, and ligatures (e.g. ﬁ → fi).
Detect and preserve intentional line breaks (e.g. poetry, code blocks).

#### I/O

##### Inputs

Raw text from PDF/OCR

##### Outputs

Cleaned text for further processing

#### Flow

#### Sample code

---
### Layout Analysis Function

#### Purpose

Extract structural information (headings, lists, tables) from PDF layout.

#### Tasks

Use pdfplumber to get text spans with (x, y, width, height) coordinates.
Group text spans by vertical/horizontal proximity to detect paragraphs, lists, or tables.
Identify headings based on font size, weight, or position (e.g. centered text).

#### I/O

##### Inputs

PDF file path

##### Outputs

Structured data (e.g. JSON) with text blocks and their metadata (font, position, etc.)

#### Flow

#### Sample code

---
### Math Detection and Conversion Function

#### Purpose

Isolate and convert math expressions to KaTeX.

#### Tasks

Use regex to detect inline math (e.g. $...$, \(...\)) or block math (e.g. $$...$$).
For non-LaTeX math, use OCR (e.g. Mathpix) to convert images to LaTeX.
Validate KaTeX output by rendering it (e.g. using katex or IPython.display.Latex).

#### I/O

##### Inputs

Raw text or image regions

##### Outputs

Text with math wrapped in KaTeX

#### Flow

#### Sample code

---
### Table Detection and Conversion Function

#### Purpose

Extract and format tables from PDFs.

#### Tasks

Use camelot or pdfplumber to detect tables in PDFs.
For image tables, use OpenCV + pytesseract to detect grid lines and extract cell contents.
Convert tables to Markdown format.

#### I/O

##### Inputs

PDF file or OCR output

##### Outputs

Markdown tables

#### Flow

#### Sample code


---
### Post-Processing Function

#### Purpose

Final cleanup and validation.

#### Tasks

Ensure consistent Markdown syntax (e.g. # Heading 1 vs. Heading 1\n=====).
Validate KaTeX equations (e.g. check for unmatched $ or \().
Check for and fix common issues (e.g. missing spaces after headings).

#### I/O

##### Inputs

Formatted Markdown

##### Outputs

Final/validated Markdown

#### Flow

#### Sample code


---
### Configuration Management

#### Purpose

Allow customization for different use cases.

#### Tasks

Support user-defined rules (e.g. custom heading levels, math delimiters).
Provide presets for common formats (e.g. academic papers, textbooks).

#### I/O

##### Inputs

User config file (e.g. YAML/JSON)

##### Outputs

Applied to all processing steps

#### Flow

#### Sample code


---
### Error Handling and Logging

#### Purpose

Debug and improve the pipeline.

#### Tasks

Log errors (e.g. failed OCR, unparseable math).
Provide warnings for ambiguous cases (e.g. "Line 42: Possible heading detected but font size unclear").
Allow manual override for edge cases.

#### I/O

##### Inputs

##### Outputs

#### Flow

#### Sample code

---
### Batch Processing

#### Purpose

Process multiple PDFs efficiently.

#### Tasks

Support directory input (e.g. /path/to/pdfs/).
Parallelize OCR and formatting for speed.
Generate a summary report (e.g. success/failure per file).

#### I/O

##### Inputs

##### Outputs

#### Flow

#### Sample code

---
### Formatter function

Ensures text is accurately formatted following the advices of an adjacent MarkDown file containing all exact notations.<br>
Iadeally, a small LLM can be trained or distilled specially to accurately reproduce the desired formatting. Calling the specialised agent would then be the superior route.<br>
Another solution that is easier to process is simply to feed to an llm (availablle through an openai-type API) the raw text and the formatting requirements with instruction to rewrite the text as an output.

For ***Phase 1*** the LLM should be able to:
- remove unnecessary linebreaks and reunite paragraphs together
- add `<br>` tags in appropriate sequences in paragraphs (When the paragraph ended much before the linebreak from linewidth).
- add KaTeX tags around equations and mathematical components

___
#### I/O

##### Inputs

- `text_raw`

##### Outputs

- `text_clean`

#### Flow

#### Sample code

```py
```

---
### OCR function

#### I/O

##### Inputs

- `input_file_path` = /path/to/file.pdf
- `end_page` = $1 \leq n_{end} \lt \infty$ = Total pages in file.pdf by default
- `begin_page` = $1 \leq n_{begin} \lt \infty$ = 1 by default

##### Outputs

- Markdown .md file with proper `output_file_name` and OCR text

#### Flow

1. Does `input_file_path` exist and returns a pdf?
1. Extract the number of pages in /path/to/file.pdf stored in `input_file_pages_count`
1. Extract `input_file_name` from `input_file_path` (E.G. = 'file')
1. Load OCR model
1. from i = begin_page to end_page use OCR model to extract text and math equations
1. run formatter function on extracted text

#### Sample code

```py
```

---

# Misc

\documentclass{article}
\usepackage{amsmath}

\begin{document}
The Fibonacci sequence is given by Binet's formula:
\[
F_n = \frac{1}{\sqrt{5}} \left( \phi^n - \psi^n \right),
\]
where \(\phi = \frac{1 + \sqrt{5}}{2}\) and \(\psi = \frac{1 - \sqrt{5}}{2}\).
\end{document}

---