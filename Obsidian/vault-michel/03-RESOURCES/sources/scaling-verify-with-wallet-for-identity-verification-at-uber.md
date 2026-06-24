---
title: "Scaling Verify with Wallet for Identity Verification at Uber"
type: source
source: "Clippings/Scaling Verify with Wallet for Identity Verification at Uber.md"
created: 2026-06-23
ingested: 2026-06-23
score: D
tags: [articles, source-page]
---

## Tese central
---
title: "Scaling Verify with Wallet for Identity Verification at Uber"
source: "
author:
published:
created: 2026-06-23
description: "See how Uber used Apple® Verify with Wallet to reduce friction and improve identity verification across its apps."
tags:
  - "clippings"
---


Gabriel D'Luca

Sr Software Engineer



Beatriz Rezener

Software Engineer II



Felipe Figueiredo

Staff Software Engineer

## Introduction

Identity verification is one of the priorities of Uber’s Trusted Identity orga

## Argumentos principais
### Introduction
Identity verification is one of the priorities of Uber’s Trusted Identity organization to promote market expansion, compliance, and support legal accountability on the Uber platform. The existing portfolio of verification methods, which includes technical solutions such as [in-house document scanning]() and selfie capture, is constantly expanding at a global scale through partnerships with technology leaders in the segment.
As technology evolved, mobile wallets such as Apple Wallet gained the ability to store mobile documents (mDocs), such as mDL (Mobile Driver’s License) and photo IDs, allowing users to seamlessly present their IDs in person, in apps, or to websites for identity or age verification.
Adding to the extensive list of mechanisms for verifying a person’s identity, Uber was an early adopter of Apple's [Verify with Wallet API]() —a reliable and modern solution introduced at WWDC 2022—into multiple use cases in Uber’s cross-app Identity Verification Platform.

### About Verify with Wallet
In contrast to the verification methods operating based on document scanning or user input, Verify with Wallet merges convenience, platform security, and seamless user experiences with a privacy focus, allowing Uber apps to verify digital ID data with government-backed provenance. This verification method drastically reduces user friction, improves conversion rates by reducing operational and image processing errors, and increases the number of verified users.
The API also encourages privacy-focused practices, providing full transparency into the identity information apps request and for how long. Apps are entitled to request only the specific data required to complete the transaction, preventing users from having to overshare their identity information. Neither the issuing authority nor Apple can see when and where a user shares their mDL or photo ID.
These powerful capabilities from Verify with Wallet, now incorporated into Uber’s Identity Verification Platform, are opening doors to a new era of digital identity verification—one where users can verify their Uber account in seconds rather than minutes, without needing to locate a physical ID. By eliminating this friction, the platform enables a faster and more efficient experience across eligible use cases in Uber, Uber Eats, and Postmates.

### Challenge
Uber operates across multiple apps and marketplace segments, each with legitimately different identity verification needs: a driver onboarding flow requires different identity data than an age-gated ordering flow, which differs again from a car rental scenario.
While Verify with Wallet supports this breadth and scale through an app-level Entitlement configuration, covering the full set of data elements the app is permitted to request, each data element must still be individually approved by Apple through an [Entitlement Request]() for its intended use case. This means that the platform capabilities provided at Uber must be flexible enough to serve any combination of approved data elements, yet strict enough to ensure a given use case never exceeds its own approved scope.
In addition to the orchestration of these data elements, the solution had to address several architectural requirements:

### Architecture
#### Figure 1: Diagram of Uber’s Verify with Wallet integration.Configuring the App for Multiple Use Cases
By design, each Uber app includes an Entitlements file encompassing the full set of required identity elements for all of its use cases. The enforcement of per-use-case scoping happens in Uber’s Identity Verification Service: the back end orchestrates the identity requests, ensuring every request is strictly limited to the data elements pre-vetted for its specific use case. This approach enables platform scalability without compromising on compliance or user privacy.
Each app is also configured with an *NSIdentityUsageDescription* —a message that tells users why the app is requesting identity information—conveying the context for app-level usage. Additionally, a new [usageDescriptionKey]() API was introduced in iOS 26.2, allowing the service to tailor this message for each specific use case upon configuring the *PKIdentityRequest*.

### Next Steps
As ‌adoption towards digital identity documents continues to evolve, our focus remains on expanding the reach and technical capabilities of Uber’s integration with Verify with Wallet API. The service has been built as a platform to easily accommodate future use cases, with the flexibility to request additional specific data elements to meet the needs of different marketplace segments.
In addition, the following are potential focus areas to Uber’s Identity Verification Platform:
- **Support new digital document types**. The platform is designed to accommodate new document types with high-assurance credentials, such as Photo IDs complying to the ISO/IEC 23220-2 standard. By integrating with a wider range of document types, the service can reach a more diverse user base, while maintaining a high bar for authenticity.

### Conclusion
Integrating Apple’s Verify with Wallet marks a significant step forward for our Identity Verification Platform. This feature integration supports acceptance of reliable, government-issued digital IDs, making the identity verification process smoother, boosting successful verifications, and reinforcing our commitment to robust security and privacy.
The privacy-preserving design is built to only request the data required to complete the transaction and prevent users from having to overshare their identity information. Beyond that, the solution employs data encryption with HPKE and session transcript and validates data against the global standard ISO/IEC 18013-5.
This strong, adaptable solution reflects our ongoing dedication to user protection, privacy, and providing a straightforward experience as digital identity evolves globally.

### Acknowledgments
This product was built by a cross-functional team including areas such as design, product management, engineering, legal, marketing, business development, and partnership management.
The following people were instrumental in adopting and scaling Verify with Wallet at Uber, in addition to the authors of this post: Duncan Carey, Allan Fukasawa, Ryan Stentz, Gustavo Tiengo, Flavia Rangel, Boldtulga Ganbaatar, Victoria Reis, Shea Hoffpauer, Shalmali Rajadhyax, Gustavo Daud, Anna Gassot, and Lizzie Ross.
**Cover Photo Attribution:** *Image by Gabriel D’Luca and Victoria Reis. Apple UI elements © Apple Inc.; licensed under the* [*Apple Design Resources License Agreement*]()*.*


## Key insights
- Building a platform-agnostic mapping layer to translate Uber’s internal identity models into domain-specific objects
- Managing high-assurance cryptographic validations according to the ISO/IEC 18013-5 standard
- Establishing a reliable mechanism to track and update trust anchors as government issuing authorities rotate their root certificates

## Exemplos e evidências
See original source at `Clippings/Scaling Verify with Wallet for Identity Verification at Uber.md` for detailed examples, data, and benchmarks.

## Implicações para o vault
Links to existing concepts in vault.

## Links
- [[03-RESOURCES/concepts/ai-agents/orchestrat]]
- [[03-RESOURCES/concepts/software-engineering/verification]]
- [[03-RESOURCES/entities/Apple]]
- [[03-RESOURCES/entities/Uber]]
- [[03-RESOURCES/entities/Rust]]
