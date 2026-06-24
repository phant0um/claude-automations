---
title: "Adopting AV1 for Real-Time Communication (RTC) at Scale"
type: source
source: "Clippings/Adopting AV1 for Real-Time Communication (RTC) at Scale.md"
created: 2026-06-23
ingested: 2026-06-23
score: B
tags: [articles, source-page]
---

## Tese central
---
title: "Adopting AV1 for Real-Time Communication (RTC) at Scale"
source: "
author:
published: 2026-06-22
created: 2026-06-23
description: "Adopting AV1 for real-time communication at Meta has been a multi-year effort spanning codec selection, device eligibility, rate control, and error resilience. We’re sharing the technical and opera…"
tags:
  - "clippings"
---
- Adopting AV1 for real-time communication at Meta has been a multi-year effort spanning codec selection, device eligibility, rate 

## Argumentos principais
### Why Is Meta Interested in Adopting AV1 for RTC?
The motivation for switching to a more advanced video codec is straightforward — it delivers the same visual quality while using much less bandwidth. In offline tests, we observed at least a 20% bitrate reduction with AV1 compared with H.264/AVC under our product settings on low-end and mid-range devices. If devices can accommodate higher encoding complexity, the bitrate reductions are even greater. For real-time video calls, this means people on slower or limited networks can enjoy significantly better video quality. This is important to our users because, to meet low-latency requirements, the RTC product must handle bitrate fluctuations. In real-world networks — especially in emerging markets — video bitrates for RTC products typically range from 10 kbps to 400 kbps. Maintaining good video quality below 100 kbps remains challenging.
To evaluate the user experience across codecs, we enabled AV1 in the Messenger app and conducted a side-by-side comparison using two Android phones. In the examples below, AV1 is displayed on the right and H.264/AVC on the left, both limited to 100 kbps. The H.264/AVC video appears noticeably blurry, while the AV1 video remains much clearer — highlighting the significant advantage of AV1 for video calls under bandwidth constraints.
Video Player  <video width="600" height="360" src=" controls=""><source type="video/mp4" src="> <a href=">></video>

### The Challenges in Adopting AV1
While the comparison clearly illustrates AV1’s advantages, there are significant challenges to its adoption in RTC. Unlike video on demand (VOD), RTC systems must manage end-to-end video latency, which ideally should remain below 300 milliseconds. If latency exceeds this threshold, people begin to notice delays in the conversation.
Maintaining both high video quality and low latency is challenging. For example, multi-pass encoding techniques — which can improve quality — introduce additional delay. On the decoder side, extensive buffering further increases latency. Additionally, any sudden spikes in bitrate can cause video freezes during calls, degrading the user experience.
RTC products must also dynamically adapt to network conditions during a call. Two challenges are fluctuations in network bandwidth and packet loss.To cope with bandwidth changes, the video encoder adjusts parameters such as resolution and frame rate. However, switching resolutions typically requires a new key frame, which can cause a sudden bitrate spike and temporary video freezing. Similarly, packet loss can trigger retransmissions or force the encoder to send another key frame, both of which may lead to video freezes. Effectively managing these issues helps enable delivery of high-quality, uninterrupted video calls.

### Encoder and Decoder Selection
Choosing the right encoder and decoder is the most critical step in adopting a new codec. The computational complexity of video codecs is a significant consideration for mobile devices. While AV1 offers improved compression efficiency through advanced coding tools, these benefits come at the burden of increased computational demands, particularly during encoding.
To assess this increased complexity, in an offline experiment we integrated an open-source AV1 encoder and measured power consumption on a Pixel 8 device during a video call. The results showed a 14% increase in power usage compared to H.264/AVC — a significant challenge for mobile deployment. To address this, we adopted an internal low-complexity encoder that has similar power consumption as H.264 baseline, as detailed in the next section.
Beyond power, AV1 encoding also increases memory usage compared to H.264/AVC, leading to app crash regressions that further complicate mobile adoption.

### Low-Complexity Encoder
A strong encoder should balance visual quality against computational complexity. Low complexity encoding helps enable AV1 encoding on mid-range and low-end devices.
Compared to older codecs like H.264/AVC, newer codecs such as AV1 deliver better compression efficiency. However, these benefits are thought of to come only with higher computational complexity — this represents an obstacle to extending AV1 coverage to low-end devices.
However, a newer codec should not necessarily require a higher-complexity encoder. Because modern codecs support a larger set of coding tools, a well-designed encoder has more opportunities to find better trade-offs between quality and complexity. These trade-offs are also referred to as presets. Ideally, the encoder offers multiple presets, spanning a range from high to low complexity while still maintaining a consistent compression efficiency gain. An ultra-low-complexity preset comparable to H.264/AVC could enable shipping AV1 on low-end phones.

### Decoder Selection
After selecting the encoder, the next step is choosing the decoder. Although video decoders are generally less complex than encoders, we found that decoding complexity remains significant on mobile devices and video calling usecases, especially low-end models. In our initial A/B tests, some low-end devices could not perform real-time decoding, resulting in video freezes and audio/video synchronization issues.
We compared several open-source decoders and, after A/B testing, we selected [dav1d]() for its superior power efficiency and reliability. Our experiments also showed an increase in talk time with the dav1d decoder.

### Binary Size
Integrating the AV1 encoder and decoder into the mobile app introduces another challenge: binary size. Using libAOM as an example, AV1 support adds 1.7 MB to the application (600 kB compressed). While this may sound negligible, it’s a major challenge for a company that serves billions of users. Binary size affects update success rates, application startup time, and software health metrics like memory usage and crash rates which can negatively impact user experience. A larger binary leaves more people on older app versions and delays incoming call setup. For example a 600 kB increase could consume an entire year’s binary size budget for a large organization.
We explored several approaches to reduce the binary size.
- Our initial approach was to use a dynamic-download framework to deliver AV1 as a separate component. However, download failures — whether from poor network conditions, device issues, or random occurrences — degraded the user experience, making this approach insufficient.

### Expanding AV1 Coverage
After selecting the encoder and decoder, the next challenge was identifying which devices are eligible to use AV1. Compiling eligible iOS models was straightforward given the limited number of variants, but Android posed a far greater challenge due to the vast number of device models.
We initially tried selecting devices based on memory, release year, and Android OS version, but none of these strategies proved sufficiently reliable. Ultimately, we leveraged Meta’s in-house ML-based device eligibility framework to generate a reliable list of eligible Android devices.

### AV1 Device Eligibility
We created a machine learning (ML)-based device eligibility framework to support advanced video and audio features based on device capability:
Figure 1: Our ML-based device eligibility framework.
The idea is to use large-scale real-world statistical data to categorize device capabilities, rather than relying on lab data. This helps us scale our device eligibility system and make more accurate decisions. We propose an ML-based device eligibility approach that uses low-level performance statistical metrics collected through our logging pipeline to assess a device’s AV1 capability. The model takes these measurements as input features and outputs an rtc\_score, which quantifies the device’s overall AV1 performance. This score then informs decisions such as optimizing call settings and determining whether a device can run the AV1 codec efficiently.

### Codec Complexity Adaptation
Device eligibility lets us identify capable devices, but we discovered an additional challenge: During A/B tests, we observed calls with significant audio/video sync regressions, primarily caused by devices unable to encode or decode video in real time. Surprisingly, even a 2023 smartphone with an octa-core processor could not handle encoding at 320×180@15fps. This issue affected both H.264 and AV1, though it was more prevalent with AV1. We suspect these devices throttle CPU frequency during calls, reducing their effective capability.
As a result, enabling AV1 purely based on device name is not sufficient. We needed a more robust mechanism to adjust codec complexity based on both local and peer device status. We developed three mechanisms: adaptive encoder preset adjustment, encoding latency-aware codec switching, and decoding latency-aware codec switching.
#### Adaptive Encoder Preset Adjustment

### Improving AV1 Call Quality
The preceding sections described our framework for enabling AV1 on a wide range of devices. With this system in place, AV1 now powers the majority of mobile devices in Meta RTC (Real-Time Communication) applications.. The next challenge is further improving AV1 call quality.
As discussed earlier, RTC products must dynamically adapt to network conditions during a call. Two notable challenges are fluctuations in network bandwidth and packet loss. Accurate rate control helps address bandwidth changes. Error-resilient strategies play an important role in ensuring reliable quality in the presence of packet loss.

### Accurate Rate Control
In RTC, maintaining a constant bitrate (CBR) is important. Any instantaneous bitrate overshoot can lead to congestion and video freeze on the peer’s side. RTC applications are sensitive to instant bitrate overshoots, so simply checking average bitrate is insufficient. We use Video Buffering Verifier (VBV) delay as a metric to evaluate CBR accuracy.
#### VBV Delay
The Video Buffering Verifier (VBV) is a leaky-bucket-based measurement used to ensure that an encoded video stream can be correctly buffered and played back at the decoder.

### Error Resilience
RTC imposes strict latency constraints, while modern video codecs rely on long, tight chains of inter-frame dependencies. When a packet is lost, the receiver must send a NACK and wait a round trip for retransmission. If that fails, the dependency chain breaks and the video freezes. The receiver then requests a keyframe, which costs another round trip, but because keyframes are roughly 10x larger than typical P-frames, they can congest the network and increase packet loss, creating a problematic cycle. To mitigate this, we tuned AV1 for fast recovery and drift containment under packet loss by leveraging temporal layers (TL) and Long-Term Reference (LTR) frames.
#### Temporal Layer (TL)
Temporal layers are a form of temporal scalability used in modern video codecs (including AV1) where the encoder organizes frames into a time-based hierarchy. The base layer (temporal layer 0) provides a lower frame rate on its own, while enhancement layers (temporal layer *N*) add intermediate frames to reach higher frame rates when conditions allow. Figure 4 shows the two-layer structure we use for AV1.

### Meta’s Ongoing Journey With AV1
Adopting AV1 for real-time communication at Meta has been a multi-year effort spanning codec selection, device eligibility, rate control, and error resilience. By combining a low-complexity encoder with ML-based device eligibility, adaptive codec switching, and robust error-resilience mechanisms, we have enabled AV1 on the majority of mobile devices — delivering meaningful quality improvements, especially for users on bandwidth-constrained networks. This initiative complements our ongoing efforts to [expand AV1 for VOD applications](). As device capabilities continue to improve and ML models leverage more data, we expect AV1 coverage and call quality to keep advancing.
Meanwhile, we are working on extending AV1 to group calls. Unlike 1:1 calls, participants in group calls must decode multiple video streams, which makes increasing AV1 coverage in group calls more challenging. While software AV1 implementations aid the steady expansion of AV1 coverage, higher quality and improved features will likely require AV1 hardware support.
The benefits of AV1 are clear, and most content and RTC service providers are moving to AV1 as their flagship codec. We encourage SoC vendors to invest in HW AV1 across all device tiers to meet the AV1 requirements to deliver an improved viewer experience, device battery savings and enhanced network operator infrastructure efficiency.


## Key insights
- Adopting AV1 for real-time communication at Meta has been a multi-year effort spanning codec selection, device eligibility, rate control, and error resilience.
- We’re sharing the technical and operational challenges while deploying AV1 and expanding coverage, and how we addressed them for real-time communication.
- We’re presenting several technologies for improving AV1 call quality, including rate control and error resilience.
- Our initial approach was to use a dynamic-download framework to deliver AV1 as a separate component. However, download failures — whether from poor network conditions, device issues, or random occurrences — degraded the user experience, making this approach insufficient.
- We then focused on direct binary size optimizations. For example, the quantization matrix (QM) tool accounts for about 10% of the encoder’s library size; optimization could halve it. We also contributed size reductions optimizations to the dav1d project.
- Frequent target bitrate changes**. The client may update the encoder target bitrate frequently. A robust encoder must keep VBV delay under control — especially when the target bitrate drops sharply.

## Exemplos e evidências
See original source at `Clippings/Adopting AV1 for Real-Time Communication (RTC) at Scale.md` for detailed examples, data, and benchmarks.

## Implicações para o vault
Links to existing concepts in vault.

## Links
- [[03-RESOURCES/concepts/ai-agents/memory]]
- [[03-RESOURCES/concepts/llm-ml-foundations/quantization]]
- [[03-RESOURCES/entities/Netflix]]
