# Perceived Neighborhood Safety and Outdoor Playtime Among Children Aged 3–5 Years

![SAS](https://img.shields.io/badge/SAS-0766D1?style=for-the-badge)
![Data: NSCH 2023](https://img.shields.io/badge/Data-NSCH_2023-555555?style=for-the-badge)
[![ORCID](https://img.shields.io/badge/ORCID-A6CE39?style=for-the-badge&logo=orcid&logoColor=white)](https://orcid.org/0009-0007-5849-1761)

Project completed as part of my MPH in Epidemiology & Biostatistics at the CUNY Graduate School of Public Health and Health Policy.

---

## Background

For young children aged 3 to 5 years, outdoor play is a critical part of healthy development, supporting physical, emotional, social, and cognitive well-being. However, in the United States, outdoor play among young children has been reported to be at an all-time low, while screen time in this age group has increased.

Young children's ability to play outdoors is contingent upon parental attitudes, behavior, and support. Parental perceptions of neighborhood safety are consistently identified as important determinants of whether children are permitted to play outside, but findings are mixed regarding which neighborhood characteristics most strongly promote outdoor play, and regarding the role of socioeconomic status (SES).

Previous studies have typically included safety as a confounder alongside demographic and socioeconomic factors. To date, no study has examined neighborhood safety as the primary exposure in relation to outdoor play among young children using the 2023 National Survey of Children's Health (NSCH).

## Objective and Hypothesis

**Objective:** To assess the relationship between parental perceptions of neighborhood safety and outdoor play among young children using 2023 NSCH data.

**Hypothesis:** Parents who perceive their neighborhoods as safe will be more likely to report higher levels of outdoor playtime for their young children.

## Data

This analysis uses the **2023 National Survey of Children's Health (NSCH) Topical Public Use File**. The NSCH is funded by the Health Resources and Services Administration's Maternal and Child Health Bureau (HRSA MCHB) and conducted by the U.S. Census Bureau. It provides national- and state-level estimates of factors that affect the health of U.S. children aged 0–17 years.

The data are not included in this repository. De-identified public-use files can be downloaded from the [U.S. Census Bureau NSCH page](https://www.census.gov/programs-surveys/nsch.html).

**Study population:** Children aged 3–5 years with non-missing data on neighborhood safety and reported outdoor playtime. The observed sample included 11,675 children; across the Census Bureau's six multiply imputed federal poverty level implicates, the analytic dataset contained 70,050 observations.

**Ethics:** This study used de-identified, publicly available data and was therefore not considered human subjects research requiring IRB review.

## Measures

| Role | Variable | Categories |
|---|---|---|
| Exposure | Parent-perceived neighborhood safety ("This child is safe in our neighborhood") | Safe vs. unsafe |
| Outcome 1 | Weekday outdoor playtime | <1, 1, 2, 3, 4+ hours per day |
| Outcome 2 | Weekend outdoor playtime | <1, 1, 2, 3, 4+ hours per day |
| Confounder | Federal poverty level (FPL), multiply imputed | 0–99%, 100–199%, 200–399%, 400%+ |
| Confounder | Metropolitan statistical area (MSA) status | Metropolitan vs. non-metropolitan |
| Modifier | Child sex | Male, female |
| Modifier | Highest parental education | Less than high school, high school/GED, some college or technical school, college degree or higher |
| Modifier | Parental employment | Full-time, part-time, unemployed/working without pay/retired |
| Modifier | School status | Preschool, kindergarten, first grade |
| Modifier | Park or playground presence | Yes/no |
| Modifier | Sidewalk or walking path presence | Yes/no |
| Modifier | Neighborhood detracting elements (litter, vandalism, run-down housing) | None vs. any |

## Methods

- All analyses accounted for the NSCH complex survey design, incorporating strata, clusters, and sampling weights.
- Survey-weighted descriptive statistics summarized participant characteristics by neighborhood safety and outdoor playtime.
- **Survey-weighted multinomial logistic regression** estimated the association between neighborhood safety and each outdoor playtime outcome, with "less than 1 hour per day" as the outcome reference category.
- Models were built sequentially: crude, adjusted for FPL (Model 1), adjusted for MSA (Model 2), and adjusted for both (Model 3).
- About 20% of the NSCH sample is missing one or more FPL components, and this missingness is not completely at random. All analyses involving FPL were run across the six Census Bureau imputed implicates (FPL_I1–FPL_I6) and **pooled using Rubin's Rules** via `PROC MIANALYZE`.
- **Effect measure modification** on the multiplicative scale was assessed with interaction terms between neighborhood safety and each modifier listed above.

## Key Results

All regression estimates compare children in perceived **unsafe** neighborhoods with children in perceived **safe** neighborhoods (reference), for each level of outdoor playtime relative to less than 1 hour per day.

- Most parents perceived their neighborhood as safe (94.92%), while 5.07% perceived it as unsafe. Unsafe neighborhoods had a notably higher proportion of households at 0–99% FPL (34.3% vs. 16.4%) and with one or more detracting elements (71.8% vs. 21.6%).
- **Weekday outdoor play:** In the crude model, children in perceived unsafe neighborhoods had significantly lower log-odds of 1 hour (log-OR: −0.646, p = 0.024) and 2 hours (log-OR: −0.667, p = 0.020) of outdoor play. Adjustment for FPL attenuated these estimates, and no comparisons were statistically significant in the fully adjusted model (e.g., 1 hour: log-OR: −0.448, p = 0.144).
- **Weekend outdoor play:** In the crude model, all playtime categories had significantly lower log-odds among children in perceived unsafe neighborhoods. After full adjustment, only 4 or more hours per day remained statistically significant (log-OR: −1.021, p = 0.003).
- **Effect measure modification:** No statistically significant interaction terms were identified for either outcome across any of the seven modifiers examined. Stratified analyses were therefore not conducted.

## Conclusions

After full adjustment, evidence for the hypothesized association between perceived neighborhood safety and outdoor playtime among children aged 3 to 5 years was limited: most comparisons were not statistically significant, although children in perceived unsafe neighborhoods had significantly lower odds of 4 or more hours of weekend outdoor play. Adjustment for household income attenuated the weekday association, suggesting that income may confound the relationship between perceived neighborhood safety and outdoor playtime. The NSCH uses a broad, single-item measure of perceived safety, which may obscure relationships between specific safety domains, such as traffic safety, and play behavior. More detailed measures of neighborhood safety are needed to clarify this relationship before assessing implications for policy and programming.

**Strengths:** Large, nationally representative dataset; a wide range of socioeconomic, demographic, and neighborhood-level confounders and modifiers; survey-weighted analyses appropriate to the NSCH's complex sampling design.

**Limitations:** All measures were parent-reported, and missing responses introduce potential for bias. The broad measure of neighborhood safety does not capture specific domains such as traffic safety.

## Tables

### Table 1. Characteristics of 2023 NSCH participants aged 3–5, by perceived neighborhood safety

| Variable | Safe neighborhood, N (%) (95% CI) | Unsafe neighborhood, N (%) (95% CI) |
|---|---|---|
| **Neighborhood safety** | 22,197 (94.92%) | 950 (5.07%) |
| **Federal poverty level** | | |
| 0–99% | 2,295 (16.4%) (14.3, 18.5) | 218 (34.3%) (25.5, 43.1) |
| 100–199% | 3,228 (18.8%) (16.6, 21.0) | 226 (24.9%) (16.4, 33.5) |
| 200–399% | 6,788 (30.3%) (28.3, 32.4) | 253 (27.1%) (19.7, 34.5) |
| 400%+ | 9,886 (34.5%) (32.7, 36.2) | 253 (13.7%) (9.4, 17.9) |
| **Metropolitan statistical area** | | |
| Metropolitan area | 16,307 (86.2%) (84.9, 87.5) | 737 (86.6%) (81.4, 91.9) |
| Non-metropolitan area | 3,481 (13.8%) (12.5, 15.0) | 127 (13.4%) (8.1, 18.7) |
| **Sex of child** | | |
| Male | 11,191 (51.8%) (49.8, 53.7) | 499 (50.3%) (42.2, 58.3) |
| Female | 11,006 (48.2%) (46.3, 50.2) | 451 (49.7%) (41.7, 57.8) |
| **Parental education** | | |
| Less than high school | 334 (5.9%) (4.5, 7.2) | 36 (9.2%) (3.3, 15.2) |
| High school or GED | 2,299 (16.9%) (15.2, 18.7) | 194 (37.1%) (28.9, 45.2) |
| Some college or technical school | 3,935 (18.0%) (16.5, 19.5) | 240 (20.8%) (14.8, 26.8) |
| College degree or higher | 15,629 (59.2%) (57.2, 61.3) | 480 (32.9%) (25.9, 39.9) |
| **Parental employment status** | | |
| Full-time | 20,438 (88.9%) (87.4, 90.5) | 790 (72.7%) (64.5, 80.9) |
| Part-time | 715 (5.0%) (3.8, 6.2) | 78 (14.3%) (7.4, 21.1) |
| Unemployed/other | 836 (6.1%) (5.0, 7.2) | 70 (13.0%) (6.8, 19.3) |
| **School status** | | |
| Preschool | 12,934 (53.1%) (51.2, 55.1) | 465 (43.7%) (35.7, 51.7) |
| Kindergarten | 2,725 (14.0%) (12.5, 15.4) | 144 (27.7%) (19.1, 36.2) |
| First grade | 149 (1.1%) (0.6, 1.5) | 4 (0.2%) (0.0, 0.6) |
| Not in school | 6,224 (31.8%) (29.9, 33.7) | 318 (28.4%) (21.8, 35.0) |
| **Park/playground presence** | | |
| Present | 17,542 (77.5%) (75.7, 79.3) | 694 (71.2%) (64.0, 78.4) |
| Not present | 4,566 (22.5%) (20.7, 24.3) | 254 (28.8%) (21.6, 36.0) |
| **Neighborhood detracting elements** | | |
| None | 17,279 (78.4%) (76.9, 79.9) | 272 (28.2%) (21.0, 35.3) |
| 1 or more | 4,788 (21.6%) (20.1, 23.1) | 666 (71.8%) (64.7, 78.9) |
| **Sidewalk presence** | | |
| Sidewalk | 16,925 (75.3%) (73.5, 77.1) | 704 (72.4%) (65.3, 79.5) |
| No sidewalk | 5,256 (24.7%) (22.9, 26.5) | 240 (27.6%) (20.5, 34.7) |

Unweighted frequencies and weighted percentages (95% CI) are reported. FPL percentages are pooled across six implicates using Rubin's Rules via `PROC MIANALYZE`; all other variables are based on a single implicate. Missing values are excluded from percentage calculations.

### Table 2. Crude and adjusted log-odds ratios for weekday outdoor playtime

| Outdoor play | Crude | Model 1 (FPL) | Model 2 (MSA) | Model 3 (FPL + MSA) |
|---|---|---|---|---|
| 1 hour vs. <1 hour | −0.646 (p = 0.024) | −0.468 (p = 0.108) | −0.615 (p = 0.042) | −0.448 (p = 0.144) |
| 2 hours vs. <1 hour | −0.667 (p = 0.020) | −0.434 (p = 0.147) | −0.604 (p = 0.044) | −0.383 (p = 0.227) |
| 3 hours vs. <1 hour | −0.781 (p = 0.329) | −0.618 (p = 0.066) | −0.803 (p = 0.024) | −0.632 (p = 0.074) |
| 4+ hours vs. <1 hour | −0.703 (p = 0.327) | −0.578 (p = 0.083) | −0.773 (p = 0.024) | −0.641 (p = 0.067) |

### Table 3. Crude and adjusted log-odds ratios for weekend outdoor playtime

| Outdoor play | Crude | Model 1 (FPL) | Model 2 (MSA) | Model 3 (FPL + MSA) |
|---|---|---|---|---|
| 1 hour vs. <1 hour | −0.759 (p = 0.025) | −0.672 (p = 0.050) | −0.719 (p = 0.041) | −0.637 (p = 0.075) |
| 2 hours vs. <1 hour | −0.735 (p = 0.023) | −0.558 (p = 0.092) | −0.730 (p = 0.032) | −0.559 (p = 0.111) |
| 3 hours vs. <1 hour | −0.861 (p = 0.011) | −0.659 (p = 0.058) | −0.862 (p = 0.015) | −0.662 (p = 0.068) |
| 4+ hours vs. <1 hour | −1.189 (p < 0.001) | −1.018 (p = 0.002) | −1.205 (p < 0.001) | −1.021 (p = 0.003) |

For Tables 2 and 3: log-ORs compare perceived unsafe with perceived safe neighborhoods (reference); the outcome reference is less than 1 hour of outdoor play per day. Models 1 and 3 include FPL (reference: 400%+) and were run across all six implicates and pooled using Rubin's Rules via `PROC MIANALYZE`. The crude model and Model 2 (MSA; reference: metropolitan area) were run on a single implicate.

### Table 4. Effect measure modification (multiplicative scale): weekday outdoor playtime

Interaction term log-ORs (p-values).

| Modifier (reference) | 1 hour vs. <1 hour | 2 hours vs. <1 hour | 3 hours vs. <1 hour | 4+ hours vs. <1 hour |
|---|---|---|---|---|
| Sex of child (male) | 0.431 (0.476) | −0.002 (0.998) | 0.939 (0.168) | −0.212 (0.764) |
| Parental education (college degree or higher) | 0.646 (0.471) | 0.909 (0.425) | 0.243 (0.892) | 0.195 (0.857) |
| Parental employment (full-time) | −0.022 (0.989) | −0.077 (0.952) | 0.463 (0.713) | −0.575 (0.630) |
| School status (not in school) | 2.982 (0.522) | 2.045 (0.572) | −0.270 (0.790) | −0.651 (0.505) |
| Park/playground (present) | 0.748 (0.217) | −0.227 (0.707) | 1.183 (0.087) | 0.382 (0.598) |
| Detracting elements (none) | −0.600 (0.371) | 0.311 (0.642) | −0.462 (0.561) | −0.512 (0.513) |
| Sidewalk (present) | 0.368 (0.597) | −0.353 (0.602) | 0.491 (0.526) | −0.005 (0.994) |

### Table 5. Effect measure modification (multiplicative scale): weekend outdoor playtime

Interaction term log-ORs (p-values).

| Modifier (reference) | 1 hour vs. <1 hour | 2 hours vs. <1 hour | 3 hours vs. <1 hour | 4+ hours vs. <1 hour |
|---|---|---|---|---|
| Sex of child (male) | 0.129 (0.855) | 0.574 (0.413) | 0.229 (0.749) | 0.281 (0.684) |
| Parental education (college degree or higher) | 0.113 (0.918) | 1.295 (0.293) | 0.708 (0.535) | −0.238 (0.882) |
| Parental employment (full-time) | 0.182 (0.894) | 0.521 (0.680) | 0.730 (0.510) | 0.055 (0.964) |
| School status (not in school) | 0.095 (0.345) | 2.644 (0.506) | 3.878 (0.468) | 0.190 (0.851) |
| Park/playground (present) | 0.920 (0.200) | 0.488 (0.463) | 0.931 (0.187) | 0.091 (0.896) |
| Detracting elements (none) | −1.302 (0.103) | −0.248 (0.756) | −0.767 (0.352) | −0.431 (0.594) |
| Sidewalk (present) | 0.515 (0.504) | −0.754 (0.305) | 0.315 (0.677) | −0.349 (0.638) |

For Tables 4 and 5: all interaction models were adjusted for FPL (reference: 400%+) and MSA (reference: metropolitan area), run across all six implicates, and pooled using Rubin's Rules via `PROC MIANALYZE`. Outcome reference: less than 1 hour of outdoor play per day. Exposure reference: perceived safe neighborhood.

## Repository Contents

| File | Description |
|---|---|
| `epid622_FINAL.sas` | Full analysis code |
| `README.md` | Project overview |
| `MurrayEileen_FINALDRAFT_EPID622.docx` | Final Paper|

## How to Run

1. Download the 2023 NSCH Topical Public Use File in SAS format (see [Data](#data)).
2. Open the `.sas` file in SAS (the analysis was developed in SAS Studio OnDemand for Academics).
3. Set the data path at the top of the program to the folder containing the NSCH file.
4. Run the program from top to bottom.

## Author

**Eileen M. Murray, MPH**
Epidemiology & Biostatistics, CUNY Graduate School of Public Health and Health Policy
[ORCID: 0009-0007-5849-1761](https://orcid.org/0009-0007-5849-1761)
