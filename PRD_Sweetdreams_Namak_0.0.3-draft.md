# Social Computing Applied: Namak Use-Case · Sweetdreams in the Kitchen

## Product Requirements Document

*Disclaimer: all events narrated in this PRD are fictitious, especially when it comes to the name Namak we took as an example in this document. We had a fantastic time at the restaurant Namak and had no sanitary issue to complain about. We highly recommend this Persian cantine in the center of Paris.*

**Version:** 0.0.3-draft · Pre-architecture · Confidential  
**Contributors:** 神縁, Claude  
**Last update:** 2026-04-04 · 神縁

---

### Changelog vs 0.0.2

- **Section 01** — Restructured sensor taxonomy around the **Continuous Sensor vs. Action-Based Test** distinction; this is now the primary architectural axis of the product. Added bacterial growth proxy tier (impedance biosensors, QCM, e-nose arrays) as the strategic research bridge. Clarified ATP as a scheduled human-administered test, not a sensor. Noted cold-chain sensor partnership dependency. Added hardware market watch note: a shift to commercially available continuous bacterial sensors is a potential launch trigger.
- **Section 03** — A-01 reframed: ATP is a scheduled test input, not a continuous sensor read. A-03 (AQ) and A-04 (camera) clarified as continuous emission. New requirement A-08 added for bacterial growth proxy sensors (COULD tier, market-contingent).
- **Section 04** — Added TPM to glossary reference. Clarified at-rest encryption rationale. P95 defined. Edge-first design principle annotated with centralisation alternative.
- **Section 06** — Risk entries for false positive and anonymous false claims expanded with attack vector detail.
- **Section 08** — OQ-03 reclassified as [BB]. New OQ-09 added: market watch trigger condition for continuous bacterial sensor commercialisation.
- **Section 09** — Added: TPM, Impedance Biosensor, QCM, E-Nose, Continuous Sensor, Action-Based Test.

---

> ⚠️ **This document is a living PRD at pre-architecture stage. All requirements and open questions are subject to revision. No production code should be written until Section 08 open questions marked as build blockers [BB] are resolved.**

### ToDo

- [ ] Validate sensor cost envelope with hardware partner (ATP meter + air quality baseline)
- [ ] Legal review: anonymisation requirements for client-side health signal reporting (GDPR, RGPD)
- [ ] Define "AI fabric" governance model — federated vs. centralised registry
- [ ] Map existing French/EU food safety reporting obligations (DGAL, RASFF) to automation hooks
- [ ] Decide on device form factor priority: portable audit tool (Case 1) vs. fixed station (Case 2) for v1 PoC
- [ ] **[MARKET WATCH]** Track commercialisation of impedance biosensor and QCM-based continuous bacterial detection — a viable unit at < €500 is a potential product launch trigger (see OQ-09)

---

## Table of Contents

1. [Vision & Problem Statement](#section-01-vision--problem-statement)
2. [Actors & User Stories](#section-02-actors--user-stories)
3. [Functional Requirements](#section-03-functional-requirements)
4. [Non-Functional Requirements](#section-04-non-functional-requirements)
5. [Data Sources & Architecture](#section-05-data-sources--architecture)
6. [Risk Matrix](#section-06-risk-matrix)
7. [Sequencing](#section-07-sequencing)
8. [Open Questions Log](#section-08-open-questions-log)
9. [Glossary of Terms](#section-09-glossary-of-terms)

---

# SECTION 01: Vision & Problem Statement

## 1.1 Vision

Namak is a symbolic stand-in for the full universe of food-service operators — from the independent cantine to industrial canteens and large restaurant chains. The core hypothesis: food safety monitoring, today largely manual, periodic, and siloed, can become **continuous, connected, and predictive** by stitching together low-cost sensors, edge AI, and a shared interoperability fabric (the "AI fabric").

The system operates on two complementary signal loops:

**Outbound (restaurant → fabric):** Sensor readings on surfaces, food batches, air quality, and cold-chain integrity are processed at the edge device. Anomalies above defined thresholds trigger structured alerts published to the AI fabric, which routes them to relevant actors (clients, auditors, suppliers, regulatory bodies).

**Inbound (client → fabric → restaurant):** Clients experiencing gastrointestinal symptoms within a configurable post-visit window (default: 72 hours) can — manually or via an AI agent acting on their behalf — submit an anonymised signal to the fabric. The restaurant receives an aggregated risk indicator, not individual identity data, preserving privacy while enabling epidemiological pattern detection.

The long-term ambition is a **trusted, decentralised food safety commons** — an always-on sanitary layer beneath every food transaction.

## 1.2 The Opportunity

**For food operators:** Real-time sanitary monitoring replaces costly periodic audits. Automated alerts reduce response time from hours to seconds. Reputational risk from false accusations can be countered with verifiable, timestamped sensor logs and immediate client verification.

**For clients:** Transparent access to the sanitary status of places they visit. Automatic, anonymous health signal reporting without manual effort.

**For auditors:** Continuous data streams replace point-in-time inspections. Audit labor shifts toward investigation of flagged anomalies rather than routine checks.

**For regulators:** Aggregated, anonymised signal feeds (e.g., toward DGAL / RASFF) enable faster outbreak detection at the population level.

**Market context:** The global food safety testing market was valued at approximately $24 billion in 2024 and is growing at ~7% CAGR. IoT-enabled continuous monitoring is an emerging and underpenetrated segment, particularly for SME food operators.

## 1.3 Sensor Taxonomy

### 1.3.1 The Core Distinction: Continuous Sensors vs. Action-Based Tests

This is the **primary architectural axis** of the product. Understanding which detection modalities are truly continuous (no human action, no consumable) versus action-based (require a human operator, a swab, a cartridge, or a reagent) determines what the system can promise and at what cost.

| **Category** | **Definition** | **Human action required?** | **Consumable?** | **v1 role** |
|---|---|---|---|---|
| **Continuous Sensor** | Emits readings autonomously, indefinitely, without intervention | ❌ No | ❌ No | Always-on monitoring backbone |
| **Action-Based Test** | Produces a reading only when a human initiates the procedure | ✅ Yes | Usually yes | Scheduled compliance verification; event-triggered investigation |

> ⚠️ **As of 2026, no commercially available, affordable continuous sensor exists for direct bacterial detection.** All specific pathogen identification (E. coli, Salmonella, Listeria) requires an action-based test. The product's continuous monitoring capability is therefore built on **indirect bacterial proxies** — environmental conditions that correlate with bacterial growth risk — not on direct bacterial measurement.
>
> 🔭 **Market watch:** Research-stage technologies (impedance biosensors, QCM, advanced e-nose arrays) are progressing toward commercial viability. A breakthrough to sub-€500 unit cost for continuous bacterial detection is a **potential product launch trigger** that this PRD must remain positioned to absorb (see OQ-09).

### 1.3.2 Sensor & Test Stack

| **Tier** | **Modality** | **Category** | **What It Detects** | **Readout** | **Approx. Unit Cost** | **v1 Priority** |
|---|---|---|---|---|---|---|
| 1 | Temperature / Humidity | ✅ Continuous Sensor | Cold-chain integrity; bacterial growth preconditions | Continuous | 2–20€ (Low-cost enough? previously 20-80) | **MUST** |
| 2 | Air Quality — CO₂ / VOC / PM2.5 | ✅ Continuous Sensor | Ventilation quality; broad spoilage VOC signatures; airborne particulate load | Continuous | 3–30€ (Low-cost enough? previously 50-300) | **SHOULD** |
| 3 | Camera (ML/RL visual inspection) | ✅ Continuous Sensor | Visual spoilage and surface contamination cues | Continuous (inference on frame) | €20–€300 (module) | **SHOULD** |
| 4 | Electronic Nose (e-nose array) | ✅ Continuous Sensor *(with calibration)* | VOC metabolite patterns associated with specific bacterial genera; closer to bacterial growth proxy than generic AQ | Minutes per classification | €200–€800 | **COULD** |
| 5 | Impedance Biosensor | 🔭 Research → Continuous Sensor | Bacterial biofilm formation on electrode surface; semi-continuous growth detection without consumable | Semi-continuous | Research-grade; target < €500 | **FUTURE / Launch Trigger** |
| 6 | Quartz Crystal Microbalance (QCM) | 🔭 Research → Continuous Sensor | Nanogram-level mass changes from bacterial adhesion on coated surface; continuous biofilm proxy | Semi-continuous | Research-grade | **FUTURE / Launch Trigger** |
| 7 | ATP Bioluminescence | ⚙️ Action-Based Test | Surface biological load (proxy for contamination); not pathogen-specific | ~15 sec per swab | €500–€1,000 (reader) + €1–3/swab | **MUST** *(scheduled test)* |
| 8 | Electrochemical Biosensor (cartridge) | ⚙️ Action-Based Test | Specific pathogen detection (E. coli, Salmonella) on food or surface sample | Minutes | €100–€500 per test | **COULD** *(event-triggered only)* |
| 9 | Optical Biosensor / Quantum Dot | ⚙️ Action-Based Test | High-specificity pathogen identification; near-lab conditions required | Lab / near-lab | Research-grade | **FUTURE** |

### 1.3.3 Tier Detail: Continuous Sensors

**Temperature & Humidity (Tier 1)**
The highest-confidence continuous bacterial growth proxy available. Temperature excursion is the single most predictive environmental precursor to pathogenic bacterial growth (the "danger zone" 4–63°C for most food pathogens). Inexpensive, deployable across refrigeration units, food storage areas, and preparation surfaces.

*Integration note:* Cold-chain temperature sensors are frequently already embedded in commercial refrigeration units. Accessing their data streams requires either a manufacturer partnership (preferred for data quality and warranty compliance) or an independent external probe (simpler to deploy, potentially redundant with built-in systems). This dependency must be resolved before v1 hardware BOM is finalised.

**Air Quality — CO₂ / VOC / PM2.5 (Tier 2)**
The most practically useful continuous sensing tier for v1. Three sub-modalities:
- **CO₂:** Proxy for ventilation quality. Poor ventilation elevates humidity and temperature variance — indirect bacterial growth risk amplifier.
- **VOCs:** Many spoilage-associated bacteria produce characteristic volatile metabolites (acids, alcohols, amines) as they grow. Broad-spectrum metal-oxide sensors (MQ-series, SGP-series) detect aggregate VOC load; insufficient to discriminate specific bacterial species but useful as a continuous anomaly flag. *Calibration note: high-aromatic kitchens (Persian, South Asian, North African cuisine profiles) generate structurally elevated baseline VOC readings from spices and cooking fumes. Kitchen-type-specific baseline calibration is required (see OQ-06).*
- **PM2.5 / PM10:** Airborne particulate load relevant to HACCP compliance documentation and general hygiene assessment.

**Camera — Visual ML/RL Model (Tier 3)**
A lightweight convolutional model (MobileNet-class or equivalent) runs inference at the edge on camera input, outputting a contamination probability score (0–1) per frame or per inspection trigger. Cross-referenced with Tier 1–2 readings to raise confidence before a fabric alert is published. Raw image data never leaves the edge device; only the inference score transits the fabric.

Federated learning loop: model weights updated monthly from anonymised gradient aggregation across the operator network.

**Electronic Nose — VOC Pattern Array (Tier 4)**
Distinct from the broad-spectrum AQ sensor. An e-nose uses an array of sensors with partially overlapping VOC sensitivities, producing a multi-dimensional "smell fingerprint" that can be trained to discriminate bacterial genera (e.g., Pseudomonas vs. Enterobacteriaceae families) based on their metabolite profiles. Commercially available units exist (Airsense Analytics, Alpha MOS, Sensigent) but require per-deployment training data. Closer to a true bacterial growth proxy than Tier 2, but requires significant calibration investment.

### 1.3.4 Tier Detail: Action-Based Tests

**ATP Bioluminescence (Tier 7)**
The industry de facto. A swab is taken from a surface, inserted into a handheld luminometer (e.g., 3M Clean-Trace, Hygiena SystemSURE), and a Relative Light Unit (RLU) score returned in ~15 seconds. Above a configurable threshold, an alert is triggered.

*Classification note:* ATP is an action-based test, not a continuous sensor. It cannot be automated without a dedicated swab-delivery mechanism (robotic arm or equivalent — excluded from v1 scope). It is a compliance and investigation tool, not a monitoring backbone. In the system, it serves as: (a) a scheduled audit data point logged to the operator's fabric profile, and (b) a confirmation tool triggered by a Tier 1–3 anomaly event.

*Limitation:* Measures total biological load — food residue, human cells, and bacteria all contribute to RLU. Cannot identify which pathogen is present. A contamination proxy, not a diagnostic.

**Electrochemical Biosensor — Pathogen-Specific Cartridge (Tier 8)**
Research and early-commercial units (e.g., bioMérieux GENE-UP, some lateral-flow immunoassay formats) can detect specific pathogens from a food or surface sample in minutes. Currently cartridge-based (single-use), requiring human sample preparation. Cost per test remains high for routine use.

*Use in this system:* Event-triggered only — deployed by an auditor or operator staff when a Tier 1–3 anomaly reaches CRITICAL classification and specific pathogen confirmation is required before a fabric alert is escalated to regulatory endpoints.

### 1.3.5 Device Form Factors

| **Case** | **Description** | **Sensor tiers onboard** | **Target Actor** | **v1 Candidate** |
|---|---|---|---|---|
| Case 1 | Portable handheld audit tool | Tier 7 (ATP reader), optionally Tier 8 | External auditor / internal hygiene team | ✅ Yes |
| Case 2 | Fixed onboarded station (edge hub) | Tier 1, 2, 3 continuous; Tier 7 on audit visit | Restaurant operator | ✅ Yes |
| Case 3 | Mobile robotised agent | All tiers; automated Tier 7 swab delivery | Large-scale operators, industrial kitchens | ❌ Future |

For v1 PoC: **Case 2 is the primary monitoring device** (continuous always-on); **Case 1 is the audit companion** (action-based test logging). Together they cover the full sensor/test stack at v1 scope.

---

# SECTION 02: Actors & User Stories

## 2.1 Actor Definitions

| **Actor** | **Description** | **Primary Interaction Point** |
|---|---|---|
| Client | End consumer who eats at a Namak-type establishment or purchases food products | Mobile app / AI personal agent / passive notification |
| Namak / Operator | Food-service operator responsible for kitchen hygiene and food safety | Dashboard / automated alerts / AI fabric publisher |
| Auditor | External or internal food safety inspector performing periodic or event-triggered checks | Portable device (Case 1) / audit portal / label issuance |
| Supplier | Food ingredient / product supplier upstream of the operator | AI fabric subscriber / automated reorder receiver |
| Regulatory Authority | Public health body (DGAL, ARS, RASFF equivalent) receiving aggregated outbreak signals | Read-only anonymised feed / alert escalation endpoint |
| AI Personal Agent | Client-side autonomous agent tracking meal history and health signals | AI fabric anonymous signal emitter |

## 2.2 User Stories

### Client

- As a client, I want to receive an immediate notification if a food safety alert is emitted for a restaurant I recently visited or a product I recently purchased.
- As a client, I want an AI agent on my personal systems to automatically and anonymously report a potential food-linked health event to the AI fabric within a configurable time window (default: 72h post-meal), without exposing my identity.
- As a client, I want to consult the current sanitary label and recent sensor history of a restaurant before deciding to eat there.
- As a client, I want to opt out of all health signal collection at any time, with immediate effect and data deletion.

### Namak / Operator

- As a food operator, I want continuous monitoring of critical kitchen surfaces, food storage areas, and ambient air quality, with a live dashboard accessible to my team.
- As a food operator, I want automated alerts published to the AI fabric when sensor readings exceed safety thresholds, without requiring manual intervention.
- As a food operator, I want to automatically initiate food discard, surface cleaning workflows, and supplier reorders when a contamination event is confirmed.
- As a food operator, I want verified, timestamped sensor logs that I can use to demonstrate due diligence in the event of a wrongful accusation or disputed illness claim.
- As a food operator, I want a sanitary quality label, continuously updated from live sensor data, visible to clients in real time.
- As a food operator, I want to control which alert types are escalated to regulators versus handled internally.

### Auditor

- As an external auditor, I want to conduct swab-and-scan inspections using the portable device (Case 1), with results automatically logged to the AI fabric under the relevant operator's profile.
- As an auditor, I want to issue a verifiable, timestamped quality label after a passed inspection, cryptographically linked to sensor evidence.
- As an auditor, I want to review the continuous sensor history of an operator before an on-site visit to target my inspection toward flagged zones or time windows.

### Supplier

- As a supplier, I want to receive automated reorder signals when a specific food batch is discarded due to a contamination event, with minimum human intervention.
- As a supplier, I want to access anonymised batch-level quality reports linked to products I supplied, to identify upstream contamination patterns.

### Regulatory Authority

- As a regulatory body, I want access to an anonymised, aggregated feed of sanitary anomalies across participating operators in my jurisdiction, to accelerate outbreak detection.
- As a regulatory body, I want the system to automatically escalate events that cross defined severity thresholds (e.g., confirmed pathogen detection via Tier 8 test, or N+ correlated client illness reports) to my alert inbox.

---

# SECTION 03: Functional Requirements

*Priority levels: MUST = non-negotiable for v1. SHOULD = strongly recommended. COULD = future version.*

## 3.1 Feature Cluster A — Edge Sensing & Local Processing

| **ID** | **Priority** | **Requirement** | **Emission mode** | **Validation Criteria** |
|---|---|---|---|---|
| A-01 | MUST | The device shall ingest ATP bioluminescence test results (RLU score + zone metadata) submitted by an operator or auditor via the Case 1 or Case 2 interface, and log them to the local event queue | Action-triggered | Logged entry contains: RLU value, zone ID, operator ID, timestamp, device ID; schema validation passes 100% |
| A-02 | MUST | The device shall continuously log temperature and humidity from storage zones at configurable intervals (default: 1 min) and emit a WARNING / CRITICAL alert on threshold breach | **Continuous** | Timestamped readings logged without gap; gap > 2 min triggers a data-loss alert; threshold breach alert emitted within 30s |
| A-03 | SHOULD | The device shall continuously read VOC / CO₂ / PM2.5 air quality sensors and produce a composite Air Quality Index (AQI) score, emitted at configurable intervals (default: 5 min) | **Continuous** | AQI score correlates ≥ 0.85 with reference instrument in lab validation; kitchen-type baseline calibration profile applied |
| A-04 | SHOULD | The device shall run a visual inspection ML model on continuous camera input and emit a contamination probability score (0–1) at configurable intervals (default: 5 min) or on demand | **Continuous** *(+ on-demand)* | Model precision ≥ 0.80 on held-out labelled kitchen image test set; raw images never leave the device |
| A-05 | MUST | The device shall evaluate all sensor and test inputs against configurable threshold profiles and classify each reading as NORMAL / WARNING / CRITICAL | Both | Threshold profiles editable via admin interface; classification matches expected output on 100 test vectors |
| A-06 | MUST | The device shall operate in offline mode for up to 24h, buffering all events locally, and replay them to the fabric upon reconnection without loss | Both | Simulated 24h offline: zero event loss confirmed on reconnection |
| A-07 | COULD | The device shall fuse continuous sensor scores (Temp/Hum, AQ, Camera) and action-based test inputs (ATP) using a weighted ensemble model to produce a single Contamination Risk Score (CRS) | Both | CRS reduces false positive rate vs. any single-sensor baseline by ≥ 20% in lab validation |
| A-08 | COULD *(market-contingent)* | If a commercially viable continuous bacterial detection sensor (impedance biosensor or QCM-class, unit cost < €500) becomes available, the device firmware and ingestion schema shall be extensible to onboard it as a Tier 5/6 continuous input without architectural rework | **Continuous** | Firmware update deploys new sensor driver without changes to event schema or fabric API contract |

## 3.2 Feature Cluster B — AI Fabric Communication

| **ID** | **Priority** | **Requirement** | **Validation Criteria** |
|---|---|---|---|
| B-01 | MUST | On a CRITICAL event (from any sensor or test input), the device shall publish a structured alert payload to the AI fabric within 30 seconds of classification | End-to-end latency from sensor reading to fabric receipt ≤ 30s at P99 |
| B-02 | MUST | All alert payloads shall include: operator ID, zone ID, sensor/test type, emission mode (continuous / action-based), reading value, threshold breached, timestamp, device firmware version | Schema validation passes on 100% of published payloads |
| B-03 | MUST | The fabric shall route operator alerts to: operator dashboard, subscribed auditors, and (at configurable severity) regulatory endpoints | Routing confirmed in integration test across all three target endpoints |
| B-04 | MUST | Client health signal submissions shall be anonymised at source before fabric publication; no PII shall transit the fabric | Privacy audit: zero PII recoverable from 1,000 sampled anonymised payloads |
| B-05 | SHOULD | The fabric shall correlate inbound client illness signals with recent operator alerts and surface an aggregated risk indicator (not raw counts) to the operator, only above aggregation threshold N | Correlation logic validated on synthetic dataset of 500 matched events; N threshold prevents single-report visibility |
| B-06 | SHOULD | The fabric shall expose a read-only, aggregated, anonymised feed to regulatory subscribers via a secured API | API returns correct anonymised aggregates; no individual operator or client identifiable |
| B-07 | COULD | B2B automation hooks shall allow the fabric to trigger supplier reorder workflows upon confirmed food discard events | Successful end-to-end test with one mock supplier integration |

## 3.3 Feature Cluster C — Client-Facing Interface

| **ID** | **Priority** | **Requirement** | **Validation Criteria** |
|---|---|---|---|
| C-01 | MUST | Clients shall receive a push notification within 5 minutes of a CRITICAL alert being published for a recently visited operator | Notification latency ≤ 5 min at P95 for opted-in clients |
| C-02 | MUST | The client interface shall display the operator's current sanitary label and a human-readable summary of recent sensor history, distinguishing continuous readings from scheduled test results | UI review: label matches live fabric state; continuous vs. test distinction visible; confirmed by user test with non-technical participants |
| C-03 | SHOULD | Clients shall be able to submit a health signal report (GI symptoms) via a ≤ 3-tap flow, with explicit consent confirmation at each submission | Usability test: ≥ 80% task completion rate; consent step never skippable |
| C-04 | MUST | A clear opt-out mechanism shall be reachable in ≤ 2 taps from any screen; opt-out triggers immediate data collection cessation and initiates deletion workflow completing within 72h | Deletion confirmed within 72h in automated test; opt-out path audited quarterly |

---

# SECTION 04: Non-Functional Requirements

## 4.1 Performance

- **Continuous sensor latency:** CRITICAL alerts generated within 30 seconds of threshold breach at the edge — no cloud round-trip required for local classification.
- **Action-based test ingestion:** Test results logged to local event queue within 5 seconds of manual submission; fabric publication within 30 seconds.
- **Fabric ingestion throughput:** Designed for 10,000 participating operators at scale; v1 target 100 operators.
- **Client notification delivery:** P95 ≤ 5 minutes from fabric publication to client push delivery. *(P95 = 95th percentile: 95% of notifications delivered within this window; accounts for OS-level delivery variance without guaranteeing the tail.)*
- **Dashboard refresh:** Operator dashboard reflects continuous sensor readings with ≤ 60-second lag; action-based test results appear within 60 seconds of submission.

## 4.2 Availability

- **Edge device:** Offline-resilient. 24h local buffer. Designed for degraded connectivity environments typical of commercial kitchen infrastructure.
- **AI fabric:** Target 99.9% uptime (≤ 8.7h downtime/year). Fabric outage must not prevent edge devices from continuing local logging and local alerting.
- **Client notifications:** Best-effort; OS-level delivery outside system control.

## 4.3 Security

- **Transport:** TLS 1.3 minimum for all device ↔ fabric ↔ endpoint communications.
- **At-rest encryption:** Sensor logs and event payloads encrypted at rest on both edge device and fabric storage. *Rationale: edge devices are physically present in operator premises and exposed to theft or tampering; at-rest encryption limits data exposure in physical compromise scenarios.*
- **Device identity:** Device-to-fabric authentication via hardware-attested certificates using TPM (Trusted Platform Module) where available; API key fallback for v1 hardware without TPM support.
- **Anonymisation:** Client health signals anonymised at source using k-anonymity (k ≥ 5). No re-identification path within the fabric.
- **Access control:** RBAC — roles: Operator, Auditor, Regulator, Client, Admin. Principle of least privilege at each layer.
- **Penetration testing:** Mandatory before Phase 3. Scope: fabric API, device firmware, client app.

## 4.4 Cost & Maintenance

- **v1 device BOM targets:** < €800 per Case 2 fixed station (Tier 1+2+3 continuous sensors + edge compute + connectivity); < €600 per Case 1 portable unit (ATP reader + connectivity).
- **Consumables:** ATP swabs single-use at ~€1–3/swab. Surfaced clearly in operator onboarding.
- **Firmware:** OTA update capability required from v1. Manual update not acceptable at scale.
- **ML model retraining:** Federated pipeline; ≤ monthly cycle; raw images never leave the edge device.

## 4.5 Regulatory & Compliance

- **GDPR / RGPD:** All client data under French and EU data protection law. DPA required with all operator customers. EU data residency.
- **Food safety:** System complements, does not replace, HACCP obligations. Sensor logs structured to support HACCP documentation exports.
- **Medical device:** Client health signal submission requires legal opinion on EU MDR 2017/745 classification before v1 launch [BB].

---

# SECTION 05: Data Sources & Architecture

## 5.1 Data Sources

| **Source** | **Category** | **Data Type** | **Frequency** | **Owner** | **Sensitivity** |
|---|---|---|---|---|---|
| Temperature / Humidity sensor | ✅ Continuous | Time-series float values | 1-min default | Operator | Low |
| Air Quality sensor (CO₂, VOC, PM2.5) | ✅ Continuous | AQI sub-scores | 5-min default | Operator | Low |
| Camera (ML model output) | ✅ Continuous | Contamination probability score (0–1) | 5-min default / on-demand | Operator | Medium |
| ATP bioluminescence test | ⚙️ Action-Based | RLU score + swab zone metadata | On-demand (scheduled or event-triggered) | Operator / Auditor | Low |
| Electrochemical biosensor test | ⚙️ Action-Based | Pathogen ID + confidence score | Event-triggered only | Auditor | Medium |
| Client health signal | Action-Based (anonymous) | Anonymised symptom + timestamp + operator reference | User or agent-initiated | Client (anonymised) | High (health data) |
| Auditor inspection record | ⚙️ Action-Based | ATP batch results + pass/fail label + zone metadata | Per inspection | Auditor | Medium |
| Supplier batch data | External | Lot number, delivery timestamp, product reference | Per delivery | Supplier | Low–Medium |

## 5.2 Target Architecture (Sketch)

```
┌──────────────────────────────────────────┐
│              EDGE DEVICE                 │
│                                          │
│  CONTINUOUS SENSORS      ACTION INPUTS   │
│  [Temp/Hum] [AQ] [Cam]   [ATP] [Bio]    │
│         ↓                    ↓           │
│       Continuous          Manual entry   │
│       stream              / scan         │
│              ↘           ↙              │
│         Edge Inference Engine            │  ← Sensor fusion, threshold eval
│         (local classification + CRS)     │    offline buffering, OTA updates
│                    ↓                     │
│            Local Event Queue             │
└────────────────┬─────────────────────────┘
                 │ MQTT / HTTPS (TLS 1.3)
                 ▼
┌──────────────────────────────────────────┐
│               AI FABRIC                  │
│  Event Ingestion API                     │
│  Routing Engine                          │  ← Correlates events across
│  Anonymisation Layer                     │    continuous + action-based
│  Aggregated Analytics Store              │    inputs; routes to actors
│  B2B Automation Hooks                    │
└────┬──────┬──────┬──────┬────────────────┘
     │      │      │      │
     ▼      ▼      ▼      ▼
Operator  Client  Auditor  Regulator
Dashboard  App    Portal    Feed
```

**Key design principles:**

- **Continuous-first, test-augmented:** The always-on backbone is built on continuous sensors (Tier 1–3). Action-based tests (Tier 7–8) augment and confirm — they do not replace. This distinction must be preserved in the event schema (field: `emission_mode: continuous | action-based`) so downstream actors can calibrate their response appropriately.
- **Edge-first with centralisation optionality:** Local classification and alerting run on-device; the fabric adds routing, correlation, and aggregation. *Architecture note: centralising all alert classification to the fabric (rather than the edge) is a valid alternative that reduces device-side compute cost and simplifies firmware. This would require reliable connectivity SLA, which cannot be assumed for all operator environments. Decision deferred to architecture phase (see OQ-02 scope extension).*
- **Event-driven:** All fabric communications are structured events (JSON-LD or equivalent), not continuous raw streams. Enables async processing, replay, and audit trail.
- **Anonymisation at source:** Client health signals stripped of PII before leaving the client device. The fabric holds only anonymised boolean-equivalent signals (event occurred / did not occur, at a given operator, within a time window).
- **Decentralisation path:** v1 centralised SaaS; v2 target federated — operator data held on-premises, only anonymised aggregates transiting the fabric. v1 architecture must not foreclose this path.

---

# SECTION 06: Risk Matrix

| **Risk** | **Probability** | **Impact** | **Severity** | **Mitigation** |
|---|---|---|---|---|
| False positive from continuous sensor triggers unwarranted alert | High (proxy signals, not direct bacterial measurement) | High | 🔴 Critical | Multi-sensor CRS fusion (A-07) gates fabric publication; alert language distinguishes "environmental anomaly detected" from "contamination confirmed"; action-based test confirmation required before regulatory escalation |
| Anonymous client signals weaponised as reputational attack (coordinated false reports) | Medium (low friction to submit, anonymous) | High | 🔴 Critical | Aggregation threshold N (OQ-03, [BB]); statistical anomaly detection on signal velocity (spike in reports from a single network/device fingerprint without identifiable info); operator sees risk indicator, not raw count or individual signals |
| Client illness falsely attributed to operator (unrelated pathogen source) | High (72h window is epidemiologically noisy) | High | 🔴 Critical | Confidence scoring on correlation; time-decay weighting; clear disclaimer in client and operator UI; operator log provides verifiable counter-evidence |
| Sensor hardware failure creates undetected gap in continuous monitoring | Medium | High | 🟠 High | Data-loss alerting (A-02); redundant temperature probe; heartbeat signal from device to fabric; operator dashboard shows sensor health status |
| Cold-chain sensor integration blocked by refrigeration manufacturer | Medium (proprietary systems, no standard API) | Medium | 🟠 High | External probe fallback (independent Tier 1 sensor); manufacturer partnership scoped in Phase 1 |
| GDPR breach via client health data re-identification | Low | Very High | 🔴 Critical | k-anonymity (k ≥ 5); legal review; no PII on fabric; annual privacy audit |
| Operator alert fatigue from continuous sensor noise | High | Medium | 🟠 High | Configurable thresholds; WARNING vs CRITICAL distinction; daily digest mode option; CRS fusion reduces single-sensor noise |
| EU MDR medical device misclassification | Low | Very High | 🔴 Critical | Legal opinion required pre-launch [BB] |
| Cyber intrusion via edge device → fabric pivot | Low | Very High | 🔴 Critical | TPM certificate pinning; network segmentation; mandatory penetration test pre-Phase 3 |
| Slow SME adoption (cost / complexity) | High | Medium | 🟠 High | Case 1 portable lowers entry barrier; SaaS subscription avoids capex; auditor channel as Trojan horse for operator onboarding |
| VOC baseline interference in high-aromatic kitchens (Persian, South Asian, etc.) | High | Low–Medium | 🟡 Medium | Kitchen-type baseline calibration profile (OQ-06); AQ treated as CRS input, not standalone alert trigger |
| Continuous bacterial sensor becomes commoditised before product launch | Low (2–5 year horizon) | High (positive disruption) | 🟢 Opportunity | A-08 extensibility requirement; modular firmware architecture; market watch tracking (OQ-09) |

---

# SECTION 07: Sequencing

## Phase 1 — Scope Validation (Current · Q2 2026)

**Objective:** Confirm technical feasibility, sensor selection, and regulatory posture before any build commitment.

- [ ] Hardware sourcing: benchmark 2–3 ATP meter candidates (Case 1); select Tier 1 + Tier 2 continuous sensor modules for Case 2 prototype
- [ ] Refrigeration manufacturer outreach: assess cold-chain sensor integration feasibility vs. external probe fallback
- [ ] Legal opinion: GDPR anonymisation model + EU MDR classification [BB]
- [ ] Define AI fabric governance model (centralised SaaS vs. federated) [BB]
- [ ] Map HACCP documentation integration requirements with one pilot operator
- [ ] Identify and contract one pilot operator (Namak-type, Paris)
- [ ] OQ-06: initiate VOC baseline characterisation study for target kitchen cuisine types

**Exit criteria:** All [BB] open questions resolved; hardware BOM confirmed < €800; legal green light on health signal model.

## Phase 2 — Proof of Concept (Q3 2026)

**Objective:** Working continuous sensor-to-dashboard pipeline + action-based test logging, with one pilot operator.

- [ ] Build Case 2 fixed station prototype (Tier 1 + Tier 2 continuous; Tier 7 ATP input)
- [ ] Build Case 1 portable prototype (ATP reader + fabric logging)
- [ ] Build operator dashboard v0 (live continuous readings, test event log, threshold alerts)
- [ ] Build minimal AI fabric v0 (event ingestion, emission mode tagging, operator routing)
- [ ] 4-week live pilot at one operator site
- [ ] Collect baseline data for ML camera model training (Tier 3)

**Exit criteria:** ≥ 2 true positive anomaly events detected via continuous sensors; ATP test results logged and visible on dashboard; zero fabric data incidents; operator qualitative validation.

## Phase 3 — v1 Deployment (Q4 2026 – Q1 2027)

**Objective:** Production system with camera model, client interface, and auditor integration.

- [ ] Deploy Tier 3 camera model on Case 2 (federated training pipeline)
- [ ] Integrate client mobile interface (notification + health signal submission + sanitary label view)
- [ ] Integrate auditor workflow (Case 1 + label issuance + operator history review)
- [ ] Implement anonymisation layer + aggregation threshold for client health signals
- [ ] Penetration test (mandatory)
- [ ] Onboard 5–10 operators, Paris region
- [ ] RGPD-compliant consent flows and privacy policy launch

**Exit criteria:** Penetration test passed; DPA signed with all operators; P95 notification latency ≤ 5 min in production; continuous vs. action-based distinction visible in client UI.

## Phase 4 — Scaling (2027+)

- Expand operator base nationally; introduce Tier 4 e-nose for high-value operator segments
- Supplier reorder automation (B-07)
- Case 3 robotised agent for industrial kitchens
- Anonymised regulatory feed to DGAL / ARS pilot
- Tier 8 electrochemical biosensor integration for on-site pathogen confirmation
- **[Market-contingent]** Tier 5/6 continuous bacterial sensor integration if commercially viable unit reaches < €500 (A-08)

---

# SECTION 08: Open Questions Log

| **ID** | **Question** | **Owner** | **Blocker?** | **Status** |
|---|---|---|---|---|
| OQ-01 | Does the client health signal submission constitute a medical device function under EU MDR 2017/745? | Legal counsel | **[BB]** | Open |
| OQ-02 | Centralised SaaS vs. federated fabric: data residency and sovereignty implications for French operators? Should edge-vs-cloud classification decision be resolved here? | Tech lead + Legal | **[BB]** | Open |
| OQ-03 | What is the minimum N for client illness signal aggregation before operator risk indicator is surfaced? Too low: operator exposed to single false report. Too high: real outbreak signal suppressed. | Data science | **[BB]** | Open |
| OQ-04 | How should the system interface with HACCP paper-based workflows at SME operators with no digital infrastructure? | Product | Not blocking | Open |
| OQ-05 | What ATP RLU threshold values define NORMAL / WARNING / CRITICAL? EU food industry standards to reference? (EN ISO 18593, EHEDG guidelines?) | Domain expert (food safety) | Not blocking | Open |
| OQ-06 | Can Tier 2 VOC sensor readings reliably discriminate cooking fumes from microbial spoilage signatures in high-aromatic kitchens? Requires cuisine-type-specific baseline calibration study. | Hardware / Data science | Not blocking | Open |
| OQ-07 | Commercial model: hardware sale + SaaS? Device loan + SaaS? Revenue share with auditors on label issuance? | Business | Not blocking | Open |
| OQ-08 | Anonymised regulatory feed (B-06): existing API infrastructure at DGAL / ARS, or greenfield interface definition required? | Business + Legal | Not blocking | Open |
| OQ-09 | **[MARKET WATCH]** At what commercial availability threshold (unit cost, detection specificity, form factor) does a continuous bacterial sensor (impedance biosensor / QCM class) trigger a product architecture revision and potential launch acceleration? Who owns this monitoring function? | Tech lead + Business | Not blocking | Open — ongoing |

---

# SECTION 09: Glossary of Terms

| **Term** | **Definition** |
|---|---|
| AI Fabric | The interoperability layer connecting all system actors. A shared, event-driven platform that ingests structured sensor events and health signals, routes alerts, and exposes aggregated feeds to authorised subscribers. Conceptually analogous to a "sanitary API layer" for the food industry. |
| Action-Based Test | A detection modality that produces a reading only when a human operator initiates a procedure — typically involving a consumable (swab, cartridge, reagent). Cannot be automated without robotic intervention. Contrast: Continuous Sensor. |
| ATP (Adenosine Triphosphate) | The universal energy molecule present in all living cells. Measured by bioluminescence as a proxy for surface biological contamination. Not pathogen-specific. |
| RLU (Relative Light Units) | Output unit of an ATP luminometer. Higher RLU = higher biological load. |
| Continuous Sensor | A detection modality that emits readings autonomously and indefinitely, without human action or consumable. Examples in this system: temperature, humidity, CO₂, VOC, PM2.5, camera. Contrast: Action-Based Test. |
| Contamination Risk Score (CRS) | Composite score (0–1) from the edge sensor fusion model, integrating continuous sensor inputs and action-based test results. Designed to reduce false positive rate vs. single-source alerts. |
| Air Quality Index (AQI) | Composite score derived from CO₂, VOC, and PM2.5 sub-readings. Used as a continuous ambient hygiene and spoilage-risk indicator. |
| Electronic Nose (E-Nose) | An array of sensors with partially overlapping VOC sensitivities, producing a multi-dimensional odour fingerprint. Can be trained to discriminate bacterial metabolite signatures. More specific than a broad-spectrum AQ sensor; less specific than a biosensor. |
| Impedance Biosensor | A research-stage continuous detection device that measures electrical impedance changes on a functionalised electrode surface as bacteria adhere and form biofilm. Potential future Continuous Sensor for direct bacterial growth detection without consumables. |
| Quartz Crystal Microbalance (QCM) | A research-stage device that detects nanogram-level mass changes on a coated piezoelectric crystal surface — sensitive enough to detect bacterial adhesion continuously. Potential future Continuous Sensor. |
| HACCP | Hazard Analysis and Critical Control Points. EU-mandated food safety management framework (EU Regulation 852/2004). |
| Edge Device | On-site hardware unit that reads sensors, runs local inference, buffers events, and communicates with the AI fabric. Case 1 (portable) or Case 2 (fixed station). |
| TPM (Trusted Platform Module) | A dedicated hardware security chip that generates and stores cryptographic keys in tamper-resistant hardware. Used here for device-to-fabric identity attestation — prevents spoofed devices from publishing fraudulent events to the fabric. |
| Federated Learning | ML training paradigm where model updates are computed locally on edge devices using local data; only gradient weights (not raw data) are shared with a central aggregator. Used here for the camera contamination model. |
| k-Anonymity | Privacy model ensuring any record is indistinguishable from at least k-1 others. Applied to client health signal aggregation to prevent re-identification. k ≥ 5 in this system. |
| P95 / P99 | Percentile latency metrics. P95 = 95% of events complete within the stated time window. P99 = 99th percentile. Used to set performance targets that account for tail variance without requiring absolute guarantees. |
| DGAL | Direction Générale de l'Alimentation. French national food safety authority. |
| RASFF | Rapid Alert System for Food and Feed. EU-level food safety alert network (EFSA / European Commission). |
| VOC (Volatile Organic Compound) | Organic chemicals that evaporate at room temperature. Bacteria produce characteristic VOC metabolite signatures during growth. Detectable by metal-oxide sensors or e-nose arrays. |
| Quantum Dot | Nanoscale semiconducting crystals that fluoresce at specific wavelengths upon binding to target molecules. In biosensor applications: functionalised to bind specific pathogens and emit a detectable optical signal. Currently research/lab-grade. |
| B2B Automation Hook | Programmatic integration point on the AI fabric enabling automated workflows with external business systems (e.g., supplier ERP for reorder triggers). |
| RGPD | Règlement Général sur la Protection des Données — French designation for GDPR. |
| BOM (Bill of Materials) | Complete itemised list of hardware components and their costs required to manufacture a device unit. |

---

*Namak Use-Case · PRD 0.0.3-draft · Paris, 2026 · Confidential · Do not distribute without permission*
