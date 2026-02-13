# Pyoopil Education Technologies — Master Research Dossier

**Compiled:** 2026-02-13 | **Sources:** 35+ (2 research passes)

---

## Company Overview

| Field | Detail |
|-------|--------|
| **Legal Name** | Pyoopil Education Technologies Private Limited |
| **CIN** | U80903DL2014PTC268009 |
| **Incorporation** | 13 June 2014 (conceptually "founded 2013") |
| **Address** | E-65 T/F, Amar Colony, Lajpat Nagar-IV, New Delhi 110024 |
| **ROC** | ROC Delhi |
| **Authorized Capital** | ₹5 Lakh |
| **Paid-Up Capital** | ₹2.1 Lakh |
| **NIC Code** | 8090 (Other Education) |
| **Entity Status** | Active (still registered as of Dec 2025; also listed as UpGrad subsidiary in Bitscale directory) |
| **Android App** | `com.pyoopil.pyoopil2` (Google Play, now defunct) |
| **Website** | pyoopil.com (abandoned post-acquisition; hijacked by Chinese spam site by 2019) |
| **Source Code** | Originally on Bitbucket (`bitbucket.org/teampyoopil/pyoopil`), archived to GitHub (`github.com/firehawk895/pyoopil`) |

---

## Co-Founders

| Name | Role | Background | Post-Pyoopil |
|------|------|-----------|--------------|
| **Harsh Mani Tripathi** | Co-Founder & CEO | EEE, SRM; Young India Fellowship (1 of 90 selected; mentored by Narayanamurthy, Deepak Parekh, Sanjeev Aga, Keki Dadiseth, Jerry Rao); Co-founder Vilikh Technologies (2010) | ~2 yrs at UpGrad (Director of Products) → CPSO at Vatsana/WittyFeed (Oct 2018) → Co-Founder & CPO at STAGE (2019–present); Angel investor (4+ companies) |
| **Ankan Adhikari** | Co-Founder | BE Information Science, MS Ramaiah Institute of Technology (2007–11); ex-Subex Ltd; email: feraasd@gmail.com; GitHub: firehawk895 | UpGrad (Team Lead, Technical) → Orderclap (Co-Founder) → **NowPurchase (Co-Founder & CTO, Jan 2021–present, Kolkata)** |
| **Aaron Basaiawmoit** | Co-Founder & Director | LinkedIn: linkedin.com/in/aaronbmoit; tagline: "Passionate about making a difference in Health, Education and Technology" | Left Nov 2014 → **CEO, Bansara Eye Care Centre, Meghalaya** (runs largest eye programme in the state; founded by J.V. Basaiawmoit). Remains on Pyoopil's board as director. |

**⚠️ Inc42 Error:** Inc42 listed "Tushar Banka" as co-founder — confirmed incorrect by HMT and all other sources (TechCircle, VCCircle, MCA records, ZaubaCorp, Tracxn).

---

## Additional Team Members

| Person | Role | Period | Source |
|--------|------|--------|--------|
| **Ram Kumar R. (r4mkum4r)** | Frontend developer; scaffolded AngularJS app; listed as bower.json author | Jun 2014 | GitHub commits |
| **H. Mittal** | Contract developer from **Green Apple Solutions Pvt Ltd** (Delhi IT outsourcing, CIN U72200DL2011PTC219220); built classroom features | Aug 2014 | GitHub commits (hmittal@greenapplesolutions.com) |

---

## Complete Timeline

| Date | Event |
|------|-------|
| **2010** | HMT co-founds Vilikh Technologies at SRM incubation centre (robotics, embedded systems, e-commerce, training). ₹12L turnover. 5 international partnerships (2 US, 1 Korea, 1 Italy). |
| **2011** | HMT wins **NEN First Dot Award** — recognized as one of India's best student entrepreneurs |
| **2011–12** | HMT selected for **Young India Fellowship** at Ashoka/UPenn (1 of 90) |
| **~2010** | HMT first connects with Vinay Singhal & Shashank Vaishnav at SRM (Vatsana/WittyFeed relationship begins — "eight years" per Vinay as of Oct 2018) |
| **2013** | Pyoopil conceptually founded by HMT, Ankan Adhikari, Aaron Basaiawmoit |
| **13 Jun 2014** | Pyoopil formally incorporated (MCA) |
| **30 Jun 2014** | Earliest code commit — 17 days after incorporation (r4mkum4r: "Library Upload Submit handler") |
| **Aug 2014** | Green Apple Solutions contracted for classroom features (H. Mittal contributes classroom landing page, join classroom, ng-dialog) |
| **Sep 2014** | Engagement report dashboard built by Ankan — analytics as early differentiator |
| **Nov 2014** | Aaron Basaiawmoit leaves Pyoopil; returns to Bansara Eye Care as CEO |
| **2014–2016** | Pyoopil raises undisclosed angel funding |
| **30 Jul 2015** | Git commit: *"Changed Aaron's cofounder status and put Ankan instead"* — org change documented in code |
| **2015–2016** | Multiple pivots: campus peer-learning → **B2B corporate training SaaS** |
| **By 2016** | Final product: (1) Marketplace of corporate trainers + (2) SaaS platform for L&D divisions to run training end-to-end |
| **17 Oct 2016** | **UpGrad acqui-hires Pyoopil** (undisclosed amount). UpGrad's first-ever acquisition. |
| **Oct 2016 – ~Oct 2018** | HMT at UpGrad in leadership positions (Director of Products per The Org) |
| **Oct 2018** | HMT joins Vatsana Technologies (WittyFeed) as CPSO |
| **~2019** | pyoopil.com domain hijacked by Chinese spam site |
| **Jan 2024** | HMT officially named Co-Founder at STAGE |

---

## Product Evolution

### Phase 1: Campus Peer Learning (2013–2015)

**Tagline:** "Communities around courses — Collaborate, engage and stay connected with your mentors and peers"

**Mission:** "At Pyoopil, we are committed to creating technology solutions in the field of education for students, educators and educational organizations. We aspire to build an organization driven by cutting-edge technology and a mission to enable millions to teach and learn seamlessly."

**Features:**
- Course creation tool — sequence of concepts, add own content or curate existing
- Chat channels per concept for peer collaboration
- Dedicated mentor channels for 1:1 interaction
- Announcements — mentors push updates to learners
- Classroom model — create/join classrooms, landing pages
- Engagement report dashboard (analytics)
- Mobile-first: Android app on Play Store

**Tech Stack (from GitHub):**
- Backend: CakePHP 2.x (Apache)
- Frontend: AngularJS ~1.2.20
- Build: Grunt (CoffeeScript Gruntfile)
- Package management: Bower
- CI: Travis CI
- Hosting: Apache (`.htaccess` present)

### Phase 2: B2B Corporate Training SaaS (2015–2016)

After "multiple failures and pivots" (HMT's own words):

- **Marketplace of corporate trainers** — connecting trainers with enterprises
- **SaaS platform for L&D divisions** — end-to-end training program management
- Mobile-based SaaS for employees to consume training on the go
- Elements of peer engagement and mentorship carried over from Phase 1
- Designed to enable mentorship, collaboration, and user engagement

---

## The Acquisition

### Deal
- **Date:** October 17, 2016
- **Type:** Acqui-hire
- **Amount:** Undisclosed
- **Acquirer:** UpGrad (U Education Management Pvt. Ltd.)
  - Founded: March 2015
  - Founders: Ronnie Screwvala, Mayank Kumar, Ravijot Chugh, Prabhav Phalgun (Kompalli)
  - Initial investment: ₹100 crore (~$16M) from Ronnie Screwvala

### Strategic Rationale
- Entry into **$1B+ corporate training market** in India
- Goal: **$100M B2B revenue in 5 years**; $20M B2C topline next fiscal
- B2B learning needs differ from B2C — couldn't use existing UpGrad product
- Got access to **product features** that would have taken longer to build
- In discussions with 30+ companies for customized programmes
- Targeting: data analytics, product management, digital marketing for corporates; SME segment; pre-joining training for fresh talent

### UpGrad's Ecosystem at Acquisition
- **Corporate clients:** Mahindra, HCL, Tata, Cognizant, Genpact
- **Content partners:** Google, Disney India, Star TV, Uber, Microsoft, BookMyShow, Gramener, Ola, Paytm, Snapdeal
- **Academic partners:** IIIT-B, Accel Partners
- **Courses:** Digital Marketing, Product Management, Android Development, PG Diploma in Data Analytics, Entrepreneurship Program
- **Planned:** Data-Driven Management course with Gramener

### Post-Acquisition
- Pyoopil team joined UpGrad
- Pyoopil was UpGrad's **first acquisition** — followed by Acadview (2018), CohortPlus (2019)
- Pyoopil remains listed as UpGrad subsidiary in business databases (Bitscale)
- No redirect set up from pyoopil.com to UpGrad

---

## Funding

| Round | Amount | Investors | Date |
|-------|--------|-----------|------|
| Angel | Undisclosed | Angel investors (names unknown) | Pre-2016 |
| Acquisition | Undisclosed | UpGrad | Oct 17, 2016 |

---

## Direct Quotes

### Harsh Mani Tripathi
> "We have been in touch with UpGrad for some time now and given our shared drive and values on how we were approaching online education, we decided it would be best to join hands and do this together."
> — *Economic Times, Oct 17, 2016*

### Mayank Kumar (Co-Founder & MD, UpGrad)
> "The Pyoopil team is driven by immense passion towards working in ed-tech and strong product expertise having built an engaging mobile learning product. They will now be part of our team, helping us in the next phase of our product evolution."
> — *TechCircle/VCCircle, Oct 17, 2016*

> "With Pyoopil, we got access to product feature, which would've taken us longer to build. The B2B learning needs are different from B2C learning needs, so I cannot use the existing product for the same. And Pyoopil has done great work in building a strong product and feature set, which makes learning in the B2B space more engaging and interactive."
> — *YourStory, Oct 2016*

> "One of the biggest things about the Pyoopil team is that they are very passionate about solving the education problem."
> — *YourStory, Oct 2016*

### Ronnie Screwvala & Mayank Kumar (Joint)
> "We are seeing a strong demand from companies who are looking to train their employees at a large scale. And UpGrad's highly engaging online learning solution allows us to deploy learning solutions for enterprise at massive scale."
> — *Inc42, Oct 17, 2016*

### Vinay Singhal (CEO, Vatsana — on HMT, Oct 2018)
> "He has been a committed investor in Vatsana and it is an extremely positive signal to have had his unwavering belief in our endeavours throughout."
> — *BuzzInContent/MediaNews4U, Oct 2018*

> "We have worked with him on multiple occasions across the last eight years of Vatsana's journey."
> — *BuzzInContent/MediaNews4U, Oct 2018*

---

## Complete Source Catalog (35 sources)

### Primary Acquisition Coverage (Oct 17, 2016)

| # | Publication | URL |
|---|------------|-----|
| 1 | Economic Times | https://economictimes.indiatimes.com/small-biz/startups/ronnie-screwvalas-ed-tech-startup-upgrad-acquihires-pyoopil/articleshow/54889970.cms |
| 2 | TechCircle | https://www.techcircle.in/2016/10/17/edu-tech-startup-upgrad-acqui-hires-learning-platform-pyoopil/ |
| 3 | VCCircle | https://www.vccircle.com/ronnie-screwvala-s-upgrad-forays-corporate-training-acqui-hires-pyoopil |
| 4 | Inc42 ⚠️ | https://inc42.com/flash-feed/upgrad-acquires-pyoopil/ |
| 5 | YourStory | https://yourstory.com/2016/10/upgrad-acquihires-pyoopil |
| 6 | MediaNama | https://www.medianama.com/2016/10/223-upgrad-acquires-pyoopil/ |
| 7 | Times of India | https://timesofindia.indiatimes.com/deals/-ma/ronnie-screwvalas-ed-tech-startup-upgrad-acquihires-pyoopil/articleshow/54891821.cms |

### Later References

| # | Publication | Date | URL |
|---|------------|------|-----|
| 8 | YourStory | Nov 2017 | https://yourstory.com/2017/11/why-ronnie-screwvala-and-mayank-of-upgrad-are-betting-on-cambridge-and-international-expansion |
| 9 | YourStory | Oct 2018 | https://yourstory.com/2018/10/upgrad-acquires-acadview |
| 10 | YourStory | Jul 2019 | https://yourstory.com/2019/07/startup-funding-roundup-ola-electric-unicorn |
| 11 | Inc42 | Jul 2020 | https://inc42.com/buzz/yatra-enters-edtech-partners-with-upgrad-to-train-smb-employees/ |
| 12 | YourStory | Jan 2022 | https://yourstory.com/2022/01/nowpurchase-seed-funding-global-suppliers-expansion-technology-team |
| 13 | Sandhill.io | Feb 2022 | https://teardowns.sandhill.io/p/upgrad |

### HMT Career Coverage

| # | Publication | Date | URL |
|---|------------|------|-----|
| 14 | BuzzInContent | Oct 2018 | https://www.buzzincontent.com/story/wittyfeed---single---s-parent-company-vatsana-technologies-appoints-harsh-mani-tripathi-as-chief-product-and-strategy-officer/ |
| 15 | MediaNews4U | Oct 2018 | https://www.medianews4u.com/wittyfeeds-parent-company-vatsana-technologies-names-harsh-mani-tripathi-as-chief-product-and-strategy-officer/ |
| 16 | Inc42 | Jan 2024 | https://inc42.com/buzz/blume-ventures-backed-ott-platform-stage-ropes-in-harsh-mani-tripathi-as-cofounder/ |

### Company Registry & Data Platforms

| # | Source | URL |
|---|--------|-----|
| 17 | AllIndiaITR | https://www.allindiaitr.com/company/pyoopil-education-technologies-private-limited/U80903DL2014PTC268009 |
| 18 | ZaubaCorp | https://www.zaubacorp.com/PYOOPIL-EDUCATION-TECHNOLOGIES-PRIVATE-LIMITED-U80903DL2014PTC268009 |
| 19 | TheCompanyCheck | https://www.thecompanycheck.com/company/pyoopil-education-technologies-private-limited/U80903DL2014PTC268009 |
| 20 | Tracxn | https://tracxn.com/d/companies/pyoopil/__lQL__Pdjiy3ciBQjHwhRcjYvcNj431LNJ_aguWJqda0 |
| 21 | Crunchbase | https://www.crunchbase.com/organization/pyoopil-education-technologies-pvt-ltd |
| 22 | PitchBook | https://pitchbook.com/profiles/company/167229-82 |
| 23 | Crunchbase (Acquisition) | https://www.crunchbase.com/acquisition/upgrad-acquires-pyoopil-education-technologies-pvt-ltd--f49ec536 |
| 24 | Bitscale AI | https://bitscale.ai/directory/upgrad |

### Institutional & Archive

| # | Source | URL |
|---|--------|-----|
| 25 | SRM University | https://www.srmist.edu.in/moment-of-pride/ |
| 26 | GitHub | https://github.com/firehawk895/pyoopil |
| 27 | Wayback (Jan 2016) | https://web.archive.org/web/20160105115520/http://pyoopil.com/ |
| 28 | Wayback (Nov 2016) | https://web.archive.org/web/20161113091935/http://pyoopil.com/ |
| 29 | The Org | https://theorg.com/org/stage-2/org-chart/harsh-mani-tripathi |

### Negative Searches (Nothing Found)

Quora, YouTube, Google Scholar, Product Hunt, AngelList/Wellfound, SlideShare/Scribd, Indian Kanoon, Facebook, LinkedIn company page, APKPure/APKMirror, UpGrad blog — all returned zero Pyoopil-specific results.

---

## Key Insights & Analysis

1. **Speed of execution:** First code 17 days after incorporation. Green Apple Solutions contracted within 2 months. Engagement analytics by month 3. This team moved fast.

2. **The pivot was real:** v1.0 was clearly a campus tool (classrooms, peer learning). The B2B corporate SaaS was a fundamentally different product and market. HMT's willingness to pivot — and admit "multiple failures" — is a pattern that repeats with WittyFeed→STAGE.

3. **Aaron's departure was early and clean:** Left 5 months after incorporation (Nov 2014), formally replaced in code 8 months later (Jul 2015). Went back to family business (eye care in Meghalaya). No drama in any source.

4. **The Vatsana thread is 16 years long:** HMT's involvement with Vinay Singhal dates to ~2010 at SRM, not 2018. This is the longest professional relationship in HMT's career and the foundation of STAGE.

5. **Pyoopil's real value was the team, not the product:** UpGrad's quotes consistently emphasize "passion" and "product expertise" over the actual Pyoopil product. Classic acqui-hire.

6. **UpGrad's ambition was massive:** ₹100Cr founding capital, $100M B2B target, partnerships with Google/Disney/Microsoft. Pyoopil gave them the B2B product capability they needed.

---

*Master dossier complete. 35 sources analyzed across 2 research passes.*
