# education-economic-development-analysis
# Economic Development and Educational Outcomes Analysis

This project analyzes the relationship between national economic development and educational outcomes using global data from the World Bank (2010–2020).

The analysis combines statistical visualization and an interactive **R Shiny dashboard** to explore how economic indicators such as GDP and poverty relate to educational access across countries.

---

# Dataset

Source: World Bank global development indicators (2010–2020)

Key variables included:

- GDP per capita
- Government expenditure on education (% of GDP)
- Primary school enrollment
- Secondary school enrollment
- Tertiary school enrollment
- Adult literacy rate
- Poverty gap ($3 per day PPP)
- Unemployment rate

The dataset was structured into a **country-year panel format** to analyze trends across time and countries.

---

# Data Preprocessing

The dataset was prepared through several steps:

- Data cleaning and formatting
- Filtering incomplete country-series observations
- Reshaping to country-year structure
- Missing value imputation using **Multiple Imputation (MICE)**

The MICE method preserves correlations between variables by iteratively modeling each variable as a function of others.

---

# Visual Analysis

Several visualization techniques were used to explore relationships between economic and educational indicators.

## World GDP Map (2010 vs 2020)

A global map comparing GDP per capita across countries in 2010 and 2020.

Countries were grouped into income categories to visualize global development patterns.

---

## Education Expenditure Trends

A line graph comparing education spending trends for selected countries:

- South Korea
- China
- United States
- Poland

This visualization highlights different policy trajectories in education investment.

---

## Global Literacy Distribution

A histogram displaying the global distribution of adult literacy rates.

This reveals that while many countries achieve high literacy levels, significant disparities still exist.

---

## GDP Distribution by Education Spending

A density plot comparing GDP per capita distributions for countries with:

- higher education spending
- lower education spending

This visualization shows that countries investing more in education often fall into higher income ranges.

---

# Interactive Dashboard (R Shiny)

An interactive **Shiny dashboard** was developed to allow dynamic exploration of the data.

The dashboard includes two main components:

### Cross-Sectional Explorer (Bubble Plot)

Users can:

- select economic indicators for the X-axis
- select educational outcomes for the Y-axis
- visualize a third variable through bubble size
- explore different years using a time slider
- apply a log scale to GDP variables

---

### Longitudinal Trend Analyzer

Users can select a country and view the historical trends of:

- primary enrollment
- secondary enrollment
- tertiary enrollment

from 2010 to 2020.

---

# Key Findings

The analysis reveals several important patterns:

- GDP per capita is strongly negatively correlated with poverty levels.
- Higher education spending is generally associated with higher GDP.
- Secondary education enrollment shows a strong relationship with economic development.
- Primary enrollment remains consistently high across most countries.
- Tertiary enrollment varies significantly across countries.

Economic development influences education differently depending on the education level.

---

# Tools Used

R

Key packages:

- tidyverse
- ggplot2
- shiny
- mice

---

# Repository Structure
economic-education-analysis
├── data
├── R
├── data_cleaning.R
├── visualization.R
└── shiny_app.R
├── report
└── Final_Report.pdf
├── presentation
└── Presentation.pdf
└── README.md

---

# Project Goal

The goal of this project is to demonstrate how data visualization and interactive dashboards can help reveal complex relationships between economic development and educational outcomes across countries.

Rather than a simple causal relationship, the results highlight a multi-dimensional interaction between economic and educational indicators.
