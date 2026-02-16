# Pyoopil Education Technologies — Second Pass Deep Research

**Compiled:** 2026-02-13 (Second Pass)
**Scope:** New findings NOT in the first comprehensive report

---

## 1. GitHub Repository Deep Dive (firehawk895/pyoopil)

**Source:** https://github.com/firehawk895/pyoopil

### Tech Stack (NEW)
The repo reveals Pyoopil v1.0's complete technology stack:
- **Backend:** CakePHP 2.x (PHP framework)
- **Frontend:** AngularJS ~1.2.20
- **Build system:** Grunt (CoffeeScript Gruntfile)
- **Package management:** Bower
- **CI:** Travis CI
- **Version control:** Originally hosted on **Bitbucket** at `https://bitbucket.org/teampyoopil/pyoopil` (migrated to GitHub later — repo ID 203861586, created as a mirror/archive)
- **API docs:** Separate `api_doc/` directory
- **Apache:** `.htaccess` present (hosted on Apache)

### Frontend Dependencies (from bower.json)
```json
{
  "name": "pyoopil",
  "version": "0.0.1",
  "authors": ["r4mkum4r.r@gmail.com"],
  "license": "MIT",
  "dependencies": {
    "angular": "~1.2.20",
    "angular-ui-router": "~0.2.10",
    "lodash": "~2.4.1",
    "toastr": "~2.0.3",
    "ngstorage": "~0.3.0",
    "pass-meter": "~1.0.0",
    "angular-re-captcha": "~0.0.3",
    "TinyScrollbar": "~2.1.8"
  }
}
```

### README Content
```
Pyoopil v1.0 in CakePhp 2.x

### Instruction to Backend
- Checkout the latest code
- Set correct timezone in app/Config/core.php
- Stop any service running on port 80
- Go to folder app/Console/
- Give 755 permission to file cake
- Run command sudo ./cake server -H api.pyoopil.localhost.com

### Instruction for AngularJS
- Checkout latest code
- run grunt serve
```

### Key Contributors (from git commits — NEW)

| Contributor | Email | GitHub Username | Activity Period | Role |
|-------------|-------|-----------------|-----------------|------|
| **Ankan Adhikari** | feraasd@gmail.com | firehawk895 | 2014-09 to 2015-07 | Co-founder, primary developer |
| **r4mkum4r** | r4mkum4r.r@gmail.com | r4mkum4r | 2014-06 to 2014-06 | Early frontend developer (bower.json author) |
| **hm6293** | hmittal@greenapplesolutions.com | — | 2014-08 to 2014-08 | Developer from **Green Apple Solutions** (outsourced/contracted dev) |

### Commit Timeline & Insights (NEW)

| Date | Commit Message | Significance |
|------|---------------|-------------|
| **2014-06-30** | "Library Upload Submit handler" (by r4mkum4r) | **Earliest commit** — development started just ~2 weeks after incorporation (June 13, 2014) |
| **2014-08-19** | "added functionality for classroom landing page" (by hm6293) | Reveals **Green Apple Solutions** was contracted for dev work. Features: classroom, join classroom, ng-dialog |
| **2014-08-22** | "added createclassroom functionality, added permission to create class" (by hm6293) | Classroom creation feature development |
| **2014-09-30** | "Reports -> Engagement report API, students Engagement report dashboard" (by Ankan) | Merge from Bitbucket `dev` branch. Shows **engagement analytics** was a product feature |
| **2015-02-11** | "Open doc harassment" (by Ankan) | Merge from dev |
| **2015-04-06** | "Merged dev into master" (by Ankan) | |
| **2015-07-30** | "**Changed Aaron's cofounder status and put Ankan instead**" (by Ankan) | 🔥 **Critical find:** This commit explicitly documents the organizational change where Aaron was replaced by Ankan as co-founder in the product/website. Dated July 2015 — ~8 months after Aaron left in Nov 2014. |

### Key Insights from GitHub
1. **Original repo was on Bitbucket** (`bitbucket.org/teampyoopil/pyoopil`), later archived to GitHub
2. **Green Apple Solutions Pvt Ltd** (Delhi-based IT services company) was contracted for initial development — developer "hm6293" (H. Mittal from greenapplesolutions.com) contributed classroom features in Aug 2014
3. The v1.0 product had a **classroom model** (create classroom, join classroom, classroom landing page) — confirms the original campus-focused peer learning concept
4. **Engagement report dashboard** was built by Sep 2014 — analytics was an early differentiator
5. Version 0.0.1 in bower.json — this was very early stage code
6. The July 30, 2015 commit explicitly updating co-founder status corroborates the Nov 2014 departure of Aaron

---

## 2. Original Bitbucket Organization

**NEW:** The original source code was hosted at `https://bitbucket.org/teampyoopil/pyoopil` (confirmed via merge commit messages). The team name on Bitbucket was **"teampyoopil"**.

---

## 3. Additional Personnel Identified

### r4mkum4r (Ram Kumar R.)
- **Email:** r4mkum4r.r@gmail.com
- **GitHub:** https://github.com/r4mkum4r
- **Role:** Early developer on Pyoopil, contributed frontend/bower setup in June 2014
- **Listed as bower.json author** — may have been the one who scaffolded the AngularJS frontend

### H. Mittal (Green Apple Solutions)
- **Email:** hmittal@greenapplesolutions.com
- **GitHub username:** hm6293
- **Company:** Green Apple Solutions Pvt Ltd (Delhi-based IT outsourcing firm, incorporated 2011, U72200DL2011PTC219220)
- **Role:** Contracted developer for classroom functionality (Aug 2014)
- **Significance:** Reveals Pyoopil outsourced some initial development to a Delhi-based IT firm

---

## 4. SRM University — Additional HMT Details (NEW)

**Source:** https://www.srmist.edu.in/moment-of-pride/

The SRM page reveals several facts not in the first report:

1. **HMT was a final year student of EEE** when selected for Young India Fellowship
2. **He was one among 90 selected** for the fellowship (competitive: picks from IIT, IIMs, top colleges)
3. **Young India Fellowship** described as "one year fully funded multi-disciplinary course" grooming "change agents of India"
4. **Fellowship mentors included:** N.R. Narayanamurthy (Infosys), Deepak Parekh (HDFC), Sanjeev Aga (Idea Cellular), Keki Dadiseth (Sony India), Jerry Rao (Mphasis)
5. **NEN First Dot Award (2011)** — HMT was "recognized as one of the best student entrepreneurs in India by National Entrepreneurship Network (NEN) and was awarded the prestigious NEN First Dot Award in 2011"
6. **Vilikh Technologies details:** Operated from SRM incubation centre; had **five international partnerships** — two in the United States, one each in **Korea** and **Italy**; ran an e-commerce portal; trained engineers; started while HMT was in his **second year**
7. **SRM alumnus connection:** Anushree K (Biotech dept, Cultural Secretary 2010-11) was selected for Young India Fellowship the previous year

---

## 5. Ankan Adhikari — Extended Career Path (NEW)

**Sources:** Datanyze, ZoomInfo, LinkedIn snippets

Full career path:
1. **ICSE** at "St. [something]" (school name truncated in ZoomInfo)
2. **BE in Information Science**, MS Ramaiah Institute of Technology (2007–2011)
3. **Subex Ltd** — Software developer (post-graduation)
4. **Pyoopil Education Technologies** — Co-Founder
5. **UpGrad** — Team Lead, Technical (post-acquisition)
6. **Orderclap** — Co-Founder
7. **NowPurchase** — Co-Founder & CTO (current, based in **Kolkata**)

**Email domains used:** @subex.com, @nowpurchase.com
**Personal email:** feraasd@gmail.com (from git commits)
**Medium:** https://medium.com/@ankanadhikari (personal blog, no Pyoopil posts — writes about movies, tech, philosophy)

---

## 6. Aaron Basaiawmoit — LinkedIn Tagline (NEW)

**Source:** https://www.linkedin.com/in/aaronbmoit/

LinkedIn headline: **"Passionate about making a difference in the fields of Health, Education and Technology!"**

Also confirmed: **Bansara Eye Care Centre is in Meghalaya state** — founded by J.V. Basaiawmoit (Aaron's father/relative), serving eye care for 30+ years. Aaron runs "the largest eye programme in the state."

---

## 7. MediaNama Article — Additional Details (NEW)

**Source:** https://www.medianama.com/2016/10/223-upgrad-acquires-pyoopil/

New details not in first report:
- MediaNama describes the tool as enabling mentors to "**create a course, add new content, build a community around courses, among others**" and notes the tool was "designed to enable **mentorship, collaboration and user engagement**"
- UpGrad founding details confirmed: **Founded March 2015** (not just by Ronnie Screwvala — also Mayank Kumar, Ravijot Chugh, Prabhav Phalgun)
- **UpGrad courses at time of acquisition:** Digital Marketing Certification, Product Management Certification, Android Development Program, PG Diploma in Data Analytics, UpGrad Entrepreneurship Program
- **UpGrad planned to launch:** Data-Driven Management course in partnership with Gramener
- **UpGrad partners (additional):** IIIT-B, Disney India, **Ola, Paytm, Snapdeal**, Accel Partners (in addition to Cognizant, Genpact, etc. already in report)
- MediaNama placed the acquisition in context of other 2016 edtech deals: NIIT/Perceptron, Byju's $50M from Chan Zuckerberg, Cuemath $4M from Sequoia

---

## 8. HMT's Twitter/X Account (NEW)

**Source:** https://x.com/harshmtripathi

- **Handle:** @HarshMTripathi
- **Joined:** January 2024
- **Following:** 9 | **Followers:** 39
- **Posts:** None (as of search date) — account created but never used
- **Note:** This is a relatively new account, created around the time he joined STAGE as co-founder

---

## 9. Pyoopil.com Domain — Post-Acquisition Fate (NEW)

The pyoopil.com domain was **not renewed after the acquisition** and was later taken over by a Chinese spam site (体育彩票 — sports lottery/decorating company). The Wayback Machine's 2019 capture shows the domain redirecting to a Chinese site. This confirms the domain was abandoned post-acquisition (no redirect to UpGrad was set up).

---

## 10. BuzzInContent vs MediaNews4U Comparison

Both articles are virtually identical in content. The only differences:
- **BuzzInContent** has slightly different headline formatting
- **MediaNews4U** includes the additional detail: "Pyoopil created a **marketplace of corporate trainers** and along with that offered a SaaS platform for L&D divisions" — this quote about the marketplace is the key differentiator already captured in report v1
- Both quote Vinay Singhal saying "We have worked with him on multiple occasions across the **last eight years** of Vatsana's journey" — meaning HMT's involvement with Vatsana dates back to ~2010

---

## 11. The Org — HMT Profile (NEW)

**Source:** https://theorg.com/org/stage-2/org-chart/harsh-mani-tripathi

HMT is listed on STAGE's org chart on The Org as Co-founder.

---

## 12. Bitscale AI Directory (NEW)

**Source:** https://bitscale.ai/directory/upgrad

Lists **Pyoopil Education Technologies Private Limited** as part of UpGrad's company directory alongside: Impartus Innovations, upGrad GSP, upGrad KnowledgeHut, Examपुर, INSOFE, upGrad Jeet, AcadView, upGrad Study Abroad, and more — confirming Pyoopil remains listed as an UpGrad subsidiary in business databases.

---

## 13. UpGrad Founding Investment (from TechCircle snippet — NEW)

**Source:** TechCircle article (snippet from search)

> "The startup was founded with an initial investment of Rs 100 crore (around $16 million) which went mainly into content, interactivity, platform, technology, assessments, adaptive learning, marketing and building a national footprint."

This refers to UpGrad's founding capital from Ronnie Screwvala — **₹100 crore (~$16M)** initial investment.

---

## 14. Negative Findings (Searched, Nothing Found)

The following searches returned zero relevant results for Pyoopil:

| Search | Result |
|--------|--------|
| **Quora** | No Pyoopil mentions |
| **YouTube** | No demo/pitch videos found |
| **Google Scholar** | No academic papers or case studies |
| **Product Hunt** | Not launched on Product Hunt |
| **AngelList/Wellfound** | No profile found |
| **SlideShare/Scribd** | No pitch decks found |
| **Indian Kanoon** | No legal filings |
| **Facebook** | No Pyoopil page found (searched, no results) |
| **LinkedIn (site:search)** | No indexed Pyoopil company page |
| **Google Play Store archives** | com.pyoopil.pyoopil2 not archived on APKPure/APKMirror |
| **UpGrad blog/website** | No mention of Pyoopil on upgrad.com |
| **Wayback Machine subpages** | Only 2 valid captures (Jan 2016, Nov 2016) — both identical. Domain was hijacked by 2019 |

---

## Summary of NEW Facts Discovered

### People
1. **r4mkum4r (Ram Kumar R.)** — early Pyoopil developer, scaffolded the AngularJS frontend
2. **H. Mittal from Green Apple Solutions** — contracted developer who built classroom features
3. **HMT won NEN First Dot Award in 2011** — recognized as one of India's best student entrepreneurs
4. **HMT selected as 1 of 90 for Young India Fellowship** — fellowship mentored by Narayanamurthy, Deepak Parekh, etc.
5. **Vilikh Technologies had 5 international partnerships** (2 US, 1 Korea, 1 Italy)
6. **HMT started Vilikh in his second year** of engineering
7. **Ankan Adhikari currently based in Kolkata**
8. **Ankan's personal email:** feraasd@gmail.com
9. **Aaron's LinkedIn:** linkedin.com/in/aaronbmoit; runs "largest eye programme in Meghalaya"
10. **HMT's Twitter:** @HarshMTripathi (joined Jan 2024, 0 posts)

### Technical
11. **Tech stack:** CakePHP 2.x backend + AngularJS 1.2.20 frontend + Grunt + Bower + Travis CI
12. **Original repo on Bitbucket** under team "teampyoopil"
13. **Green Apple Solutions Pvt Ltd** was contracted for initial development (Aug 2014)
14. **Earliest code: June 30, 2014** — just 17 days after incorporation
15. **v1.0 had classroom model** — create/join classroom, classroom landing page
16. **Engagement report dashboard** was built by Sep 2014
17. **July 30, 2015 commit** explicitly changed "Aaron's cofounder status and put Ankan instead"

### Business
18. **UpGrad's founding capital: ₹100 crore (~$16M)** from Ronnie Screwvala
19. **UpGrad founded March 2015** (confirmed by MediaNama)
20. **Additional UpGrad partners at acquisition:** Ola, Paytm, Snapdeal, IIIT-B, Accel Partners
21. **HMT's involvement with Vatsana goes back to ~2010** ("eight years" as of Oct 2018)
22. **pyoopil.com domain abandoned** post-acquisition, hijacked by Chinese spam site by 2019
23. **Pyoopil still listed as UpGrad subsidiary** in Bitscale business directory

---

*End of second pass. 23 new facts discovered from 10+ new sources.*
