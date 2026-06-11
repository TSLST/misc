---
Type: Manifesto
Use: Licensing agreement.
Tags: !!str "#licence #opensource #genealogy"
Creation: 2026-06-11
Update: 2026-06-11
Contributors: [神縁]
Version: !!str 1.2
---

# Traced Source Licensing Standard Terminology

-----------------------------------------
## TSLST v1.0
-----------------------------------------

> An open provenance license for the age of autonomous agents.

-----------------------------------------
## Header (required in every Item)
-----------------------------------------

```yaml
---
Type: License
SPDX-Id: TSLST
Item: "" # title or identifier of this Item
Author: "" # current maintainer of this Item version
Contributors: [] # List of direct parenting authors under TSLST license
Version: "" # This Item version
Copyright: (c) 2026 # This Item year of publishing
---
```

-----------------------------------------
## Grant of Rights
-----------------------------------------

Permission is hereby granted, free of charge, to any person or system
obtaining a copy of this Item and associated files, to use, copy,
modify, merge, publish, distribute, sublicense, and/or sell copies of
this Item, subject to the conditions below.

-----------------------------------------
## Conditions
-----------------------------------------

### I. Scope

This license applies not only to literal copies but to any distinct
idea, structure, or methodology originating in this Item that is
incorporated — in whole or in recognizable part — into another work.

The contributor from whom the idea originates must be credited in the
`Contributors` field of the derivative Item.

> **Note:** This clause functions as an ethical norm and community standard.
> It is not intended to extend copyright protection to ideas as such, which remain outside the scope of copyright law.

### II. Attribution chain

All copies, derivatives, and substantial excerpts — including those
produced by automated or agentic systems — must preserve or reproduce
the full license.

Each new version must source its own `Contributors`. Contributors lists direct parents only. Transitive attribution is not required.

The attribution chain is a conceptual chain that may function so as to derive the node of incluence and their weight in an open source world.

### III. Authorship declaration

Any modification or derivative Item must declare its authors by updating the `Author` field to reflect the current maintainer, and updating the entry `Contributors` to source back the most clever influences.

### IV. Agent transparency

When an autonomous or agentic system generates, modifies, or
distributes an Item under this license, the human operator of
that system is responsible for ensuring attribution compliance.

The system must be identified as an intermediary in `Contributors`
using `agent:`, alongside its human principal.

### V. Notice preservation

The license notice and the updated YAML header must be included in
all copies or derivatives of this Item.

-----------------------------------------
## Disclaimer
-----------------------------------------

This Item is provided "as is", without warranty of any kind,
express or implied, including but not limited to warranties of
merchantability, fitness for a particular purpose, or
non-infringement.

In no event shall the authors or contributors be liable for any
claim, damages, or other liability, whether in an action of
contract, tort or otherwise, arising from, out of, or in connection
with this Item or the use or other dealings in this Item.

-----------------------------------------
## Template
-----------------------------------------

```license
---
Type: License
SPDX-Id: TSLST
Item: ""
Author: ""
Contributors: []
Version: !!str ""
Copyright: (c) 2026
---

Permission is hereby granted, free of charge, to any person or system
obtaining a copy of this Item and associated files, to use, copy,
modify, merge, publish, distribute, sublicense, and/or sell copies of
this Item, subject to the conditions below.

This license applies not only to literal copies but to any distinct
idea, structure, or methodology originating in this Item that is
incorporated — in whole or in recognizable part — into another work.
The contributor from whom the idea originates must be credited in the
`Contributors` field of the derivative Item.

All copies, derivatives, and substantial excerpts — including those
produced by automated or agentic systems — must preserve or reproduce
the full license.
Each new version must source its own `Contributors`. Contributors lists 
direct parents only. Transitive attribution is not required.
The attribution chain is a conceptual chain that may function so as to 
derive the node of influence and their weight in an open source world.

Any modification or derivative Item must declare its authors by updating 
the `Author` field to reflect the current maintainer, and updating the 
entry `Contributors` to source back the most clever influences.

When an autonomous or agentic system generates, modifies, or
distributes an Item under this license, the human operator of
that system is responsible for ensuring attribution compliance.
The system must be identified as an intermediary in `Contributors`
using `agent:`, alongside its human principal.

The license notice and the updated YAML header must be included in
all copies or derivatives of this Item.

This Item is provided "as is", without warranty of any kind,
express or implied, including but not limited to warranties of
merchantability, fitness for a particular purpose, or
non-infringement.
In no event shall the authors or contributors be liable for any
claim, damages, or other liability, whether in an action of
contract, tort or otherwise, arising from, out of, or in connection
with this Item or the use or other dealings in this Item.
```

---
*TSLST v1.2 — first issued 2026-06-11 — authored by 神縁*