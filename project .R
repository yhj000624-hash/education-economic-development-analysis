setwd("/Users/yoonhyeonjeong/Desktop")

data <- read.csv("world_edu_panel.csv")



install.packages("tidyr")

install.packages("mice")

install.packages("dplyr")

library(tidyr)

library(mice)

library(dplyr)



names(data)[5:ncol(data)] <- gsub("X", "", names(data)[5:ncol(data)])

names(data)[5:ncol(data)] <- gsub("\\..*", "", names(data)[5:ncol(data)])



for(i in 5:ncol(data)){
  
  data[[i]] <- as.numeric(data[[i]])}



num_cols <- 5:ncol(data)

all_na_rows <- apply(data[, num_cols], 1, function(x) all(is.na(x)))

data_clean <- data[!all_na_rows, ]



data_long <- pivot_longer(
  
  data_clean,
  
  cols = 5:ncol(data_clean),
  
  names_to = "Year",
  
  values_to = "Value"
  
)





data_wide <- pivot_wider(
  
  data_long,
  
  c(Country.Name, Country.Code, Year),
  
  names_from = Series.Name,
  
  values_from = Value)



View(data_wide)

missing_ratio <- sum(is.na(data_wide)) / (nrow(data_wide) * ncol(data_wide))

missing_ratio





data_long$Country.Name <- as.factor(data_long$Country.Name)

data_long$Series.Name  <- as.factor(data_long$Series.Name)

data_long$Year         <- as.factor(data_long$Year)



predictor_matrix <- make.predictorMatrix(data_wide)

predictor_matrix[, c("Country.Name", "Country.Code")] <- 0



mice_out <- mice(
  
  data_wide,
  
  m = 1,
  
  method = "pmm",
  
  maxit = 20,
  
  predictorMatrix = predictor_matrix,
  
  seed = 123)



data_final <- complete(mice_out, 1)



View(data_final)

getwd()
write.csv(data_final, "/Users/yoonhyeonjeong/Desktop/world_edu_final.csv",
          row.names = FALSE)

missing_ratio <- sum(is.na(data_final)) / (nrow(data_final) * ncol(data_final))
missing_ratio



library(dplyr)
library(ggplot2)
library(tidyr)
library(readr)

data_final <- read_csv("/Users/yoonhyeonjeong/Desktop/world_edu_final.csv")

edu <- data_final %>%
  rename(
    gdp      = `GDP per capita (current US$)`,
    edu_gdp     = `Government expenditure on education, total (% of GDP)`,
    enroll_p = `School enrollment, primary (% gross)`,
    enroll_s  = `School enrollment, secondary (% gross)`,
    enroll_t  = `School enrollment, tertiary (% gross)`,
    literacy_rate    = `Literacy rate, adult total (% of people ages 15 and above)`,
    unemp_rate       = `Unemployment, total (% of total labor force) (modeled ILO estimate)`,
    poverty_gap3 = `Poverty gap at $3.00 a day (2021 PPP) (%)`
  )




# world map of gdp

library(ggplot2)
library(maps)
library(dplyr)

world_map <- map_data("world")

year_list <- c(2010, 2020)

edu_gdp_map <- edu %>%
  filter(Year %in% year_list) %>%
  select(Country.Name, Year, gdp)

world_gdp <- world_map %>%
  left_join(edu_gdp_map, by = c("region" = "Country.Name")) %>%
  filter(!is.na(Year))

world_gdp <- world_gdp %>%
  mutate(gdp_band = cut(gdp,breaks = c(0, 5000, 15000, 30000, 60000, Inf),
      labels = c("< 5k", "5k–15k", "15k–30k", "30k–60k", "60k+"),
      include.lowest = TRUE))

ggplot(world_gdp, aes(long, lat, group = group, fill = gdp_band)) +
  geom_polygon(color = "grey", size = 0.1) +
  scale_fill_manual(
    values = c(
      "< 5k"    = "yellow",
      "5k–15k"  = "orange",
      "15k–30k" = "pink",
      "30k–60k" = "purple",
      "60k+"   = "blue"
    ),
    na.value = "white"
  ) +
  facet_wrap(~ Year, ncol = 2) +
  labs(
    title = "GDP per capita (current US$) by year",
    fill  = "GDP band"
  ) +
  theme_minimal()


year_focus <- 2019


country_list <- c("Poland", "Korea, Rep.", "United States", "China")

edu_sel <- edu %>%
  filter(Country.Name %in% country_list)



# line graph

ggplot(edu_sel, aes(x = Year, y = edu_gdp, colour = Country.Name, group = Country.Name)) +
  geom_line() +
  geom_point() +
  labs(
    title = "Education expenditure (% of GDP) over time",
    x = "Year",
    y = "Education expenditure (% of GDP)",
    colour = "Country"
  )


# Histogram
  
edu_lit <- edu %>%
  filter(Year == year_focus) %>%
  filter(!is.na(literacy_rate))

ggplot(edu_lit, aes(x = literacy_rate)) +
  geom_histogram(binwidth = 5, fill = "pink", colour = "black") +
  labs(
    title = paste("Distribution of adult literacy rates in", year_focus),
    x = "Adult literacy rate (%)",
    y = "Number of countries"
  )




#Density plot  
edu_year2 <- edu %>%
  filter(Year == year_focus) %>%
  filter(!is.na(gdp), !is.na(edu_gdp))

med_edu <- median(edu_year2$edu_gdp, na.rm = TRUE)

edu_year2 <- edu_year2 %>%
  mutate(
    edu_group = ifelse(edu_gdp >= med_edu, "high_edu", "low_edu")
  )

ggplot(edu_year2, aes(x = gdp, fill = edu_group)) +
  geom_density(alpha = 0.4) +
  scale_fill_manual(values = c("high_edu" = "blue", "low_edu" = "yellow")) +
  labs(
    title = paste("GDP distribution by education spending level in", year_focus),
    x = "GDP per capita (current US$)",
    y = "Density",
    fill = "Education spending"
  )



install.packages("shiny")
install.packages("ggplot2")
install.packages("plotly")
library(shiny)
library(dplyr)
library(ggplot2)
library(plotly)

ui <- fluidPage(
  titlePanel("Education and Development Dashboard"),
  
  sidebarLayout(
    sidebarPanel(
      sliderInput("year", "Year:",
                  min = min(edu$Year),
                  max = max(edu$Year),
                  value = 2015, step = 1, sep = ""),
      
      selectInput("xvar", "X axis:",
                  choices = c(
                    "GDP per capita" = "gdp",
                    "Poverty gap (3$)" = "poverty_gap3",
                    "Unemployment rate" = "unemp_rate"
                  ),
                  selected = "gdp"),
      selectInput("yvar", "Y axis (education):",
                  choices = c(
                    "Primary enrollment" = "enroll_p",
                    "Secondary enrollment" = "enroll_s",
                    "Tertiary enrollment" = "enroll_t",
                    "Adult literacy" = "literacy_rate"
                  ),
                  selected = "enroll_s"),
      selectInput("sizevar", "Bubble size:",
                  choices = c(
                    "Education exp. (% of GDP)" = "edu_gdp",
                    "Adult literacy" = "literacy_rate"
                  ),
                  selected = "edu_gdp"),
      checkboxInput("logx", "Log10 scale for X axis", FALSE)
    ),
    
    mainPanel(
      tabsetPanel(
        tabPanel("Bubble plot", plotlyOutput("bubblePlot")),
        tabPanel("Trend line",
                 selectInput("country", "Country:",
                             choices = unique(edu$Country.Name),
                             selected = "Poland"),
                 plotOutput("trendPlot")
        )
      )  
    )
  )
)
server <- function(input, output, session) {
  # Data filtered by year
  edu$Year <- as.numeric(edu$Year)
  filtered_year <- reactive({
    edu[edu$Year == input$year,]
  })
  
  # bubble plot
  output$bubblePlot <- renderPlotly({
    df <- filtered_year()
    
    ggplotly(
      ggplot(df,
             aes(
               x = .data[[input$xvar]],
               y = .data[[input$yvar]],
               size = .data[[input$sizevar]],
               colour = poverty_gap3,
               text = Country.Name
             )) +
        geom_point(alpha = 0.7) +
        scale_size_continuous(name = input$sizevar) +
        scale_colour_viridis_c(name = "Poverty gap (3$)") +
        labs(
          title = paste("Bubble plot –", input$year),
          x = input$xvar,
          y = input$yvar
        ) +
        theme_minimal()+
        {if(input$logx) scale_x_log10()},
      tooltip = "text")
  })
  
  
  # Time-series trend of an education variable for a specific country (e.g., Poland)”
  output$trendPlot <- renderPlot({
    country_selected <- input$country 
    
    df <- edu[edu$Country.Name == country_selected, ]
    
    ggplot(df, aes(x = Year)) +
      geom_line(aes(y = enroll_p, colour = "Primary enrollment"), size = 1) +
      geom_point(aes(y = enroll_p, colour = "Primary enrollment")) +
      geom_line(aes(y = enroll_s, colour = "Secondary enrollment"), size = 1) +
      geom_point(aes(y = enroll_s, colour = "Secondary enrollment")) +
      geom_line(aes(y = enroll_t, colour = "Tertiary enrollment"), size = 1) +
      geom_point(aes(y = enroll_t, colour = "Tertiary enrollment")) +
      labs(
        title = paste("Primary vs Secondary vs Tertiary enrollment –", country_selected),
        x = "Year",
        y = "Enrollment (% gross)",
        colour = "Level"
      ) +
      theme_minimal()
  })
}

shinyApp(ui, server)

