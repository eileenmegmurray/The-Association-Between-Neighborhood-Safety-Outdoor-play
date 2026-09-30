# Perceived Neighborhood Safety and Outdoor Playtime Among Children Aged 3–5 Years

![SAS](https://img.shields.io/badge/SAS-0766D1?style=for-the-badge)
![Data: NSCH 2023](https://img.shields.io/badge/Data-NSCH_2023-555555?style=for-the-badge)
[![ORCID](https://img.shields.io/badge/ORCID-A6CE39?style=for-the-badge&logo=orcid&logoColor=white)](https://orcid.org/0009-0007-5849-1761)

Final project for EPID 622, CUNY Graduate School of Public Health and Health Policy.

---

## Abstract

**Background:** For young children aged 3 to 5 years, outdoor play is a critical part of healthy development, supporting physical, emotional, social, and cognitive well-being. However, outdoor play among young children in the United States has been reported to be at an all-time low, while screen time in this age group has increased. Parental perceptions of neighborhood safety are consistently identified as important determinants of whether children are permitted to play outside, yet previous studies have typically treated safety as a confounder rather than the primary exposure.

**Objective:** To assess the relationship between parental perceptions of neighborhood safety and outdoor play among children aged 3 to 5 years. We hypothesized that parents who perceive their neighborhoods as safe would be more likely to report higher levels of outdoor playtime for their young children.

**Methods:** A cross-sectional analysis of the 2023 National Survey of Children's Health (NSCH) was conducted among children aged 3–5 years with non-missing data on neighborhood safety and outdoor playtime (n = 11,675 children; n = 70,050 observations across six imputation implicates). The exposure was parent-perceived neighborhood safety (safe vs. unsafe). The outcomes were parent-reported weekday and weekend outdoor playtime, each categorized as less than 1, 1, 2, 3, or 4 or more hours per day and assessed separately. Survey-weighted multinomial logistic regression models accounted for the complex sampling design and were adjusted for federal poverty level (FPL) and metropolitan statistical area (MSA) status. FPL was multiply imputed by the Census Bureau, and estimates were pooled across six implicates using Rubin's Rules. Effect measure modification on the multiplicative scale was assessed via interaction terms for child sex, parental education, parental employment, school status, park or playground presence, sidewalk presence, and neighborhood detracting elements.

**Results:** Most parents perceived their neighborhood as safe (94.92%). Compared with children in perceived safe neighborhoods, children in perceived unsafe neighborhoods had significantly lower log-odds of 1 hour (log-OR: −0.646, p = 0.024) and 2 hours (log-OR: −0.667, p = 0.020) of weekday outdoor play relative to less than 1 hour in crude models; these associations were attenuated after adjustment for FPL and were not statistically significant in the fully adjusted model (e.g., 1 hour: log-OR: −0.448, p = 0.144). For weekend outdoor play, crude associations were significant across all playtime categories, and the association for 4 or more hours per day remained significant after full adjustment (log-OR: −1.021, p = 0.003). No significant effect measure modification was identified for either outcome.

**Conclusions:** After full adjustment, evidence for an association between perceived neighborhood safety and outdoor playtime among children aged 3 to 5 years was limited, although children in perceived unsafe neighborhoods had lower odds of 4 or more hours of weekend outdoor play. Attenuation after adjustment for household income suggests that income may confound this relationship. The NSCH's broad, single-item measure of perceived safety may obscure relationships between specific safety domains, such as traffic safety, and play behavior; more detailed measures are needed before assessing implications for policy and programming.

**Keywords:** Outdoor play, neighborhood safety, early childhood, built environment, socioeconomic status, NSCH

## Data

This analysis uses the **2023 NSCH Topical Public Use File**, funded by the Health Resources and Services Administration's Maternal and Child Health Bureau (HRSA MCHB) and conducted by the U.S. Census Bureau. The data are not included in this repository; de-identified public-use files can be downloaded from the [U.S. Census Bureau NSCH page](https://www.census.gov/programs-surveys/nsch.html). Because the data are de-identified and publicly available, this study was not considered human subjects research requiring IRB review.

## Repository Contents

| File | Description |
|---|---|
| `MurrayEileen_FINALDRAFT_EPID622.docx` | Final Paper|
| `README.md` | Project overview |
|`epid622_FINAL.sas`| Full SAS code |

## How to Run

1. Download the 2023 NSCH Topical Public Use File in SAS format (see [Data](#data)).
2. Open the `.sas` file in SAS (the analysis was developed in SAS Studio OnDemand for Academics).
3. Set the data path at the top of the program to the folder containing the NSCH file.
4. Run the program from top to bottom.

## Author

**Eileen M. Murray, MPH**
Epidemiology & Biostatistics, CUNY Graduate School of Public Health and Health Policy
[ORCID: 0009-0007-5849-1761](https://orcid.org/0009-0007-5849-1761)
