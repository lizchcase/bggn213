# Liz Chamiec-Case
# A59011740
# Lab 5: ggplot2

## COMMON PLOT TYPES

# Q. Which plot types are typically NOT used to compare distributions of numeric variables?
#         network plots

# Q. Which statement about data visualization with ggplot2 is incorrect?
#         ggplot2 is the only way to make plots in R

## SCATTER PLOTS

library(ggplot2)
ggplot(cars)

ggplot(cars) +
  aes(x=speed, y=dist) +
  geom_point()

# Q. Which geometric layer should be used to create scatter plots in ggplot2?
#         geom_scatter()

# Q. In your own RStudio can you add a trend line layer to help show the relationship between the plot variables with the geom_smooth() function?
# Q. Can you finish this plot by adding various label annotations with the labs() function and changing the plot look to a more conservative “black & white” theme by adding the theme_bw() function:

ggplot(cars) +
  aes(x=speed, y=dist) +
  geom_point() +
  geom_smooth() +
  theme_bw() +
  labs(title='Speeds and Distances of Cars',xlab='Speed',ylab='Distance')

# gene regulation data

url <- "https://bioboot.github.io/bimm143_S20/class-material/up_down_expression.txt"
genes <- read.delim(url)
head(genes)

number.genes <- nrow(genes) # 5196 genes
num.cols <- ncol(genes) # 4 columns
col.names <- colnames(genes)

state <- table(genes$State) # 127 upregulated genes

frac.upregulated <- round(state[3]/number.genes*100, 2) # 2.44% of genes are upregulated

ggplot(genes,aes(x=Condition1,y=Condition2,color=State)) + 
  geom_point() +
  scale_colour_manual( values=c("blue","gray","red") ) +
  labs(title='Gene Expression Changes Upon Drug Treatment',xlab='Control (No Drug)',ylab='Drug Treatment',legend='right')

library(gapminder)
library(dplyr)

gapminder.url <- "https://raw.githubusercontent.com/jennybc/gapminder/master/inst/extdata/gapminder.tsv"
gapminder <- read.delim(gapminder.url)
gapminder.2007 <- gapminder %>% 
  filter(year==2007)

ggplot(gapminder.2007) +
  aes(x=gdpPercap, y=lifeExp, color=continent, size=pop) +
  geom_point(alpha=0.4)

# plot for 1957
gapminder.1957 <- gapminder %>%
  filter(year == 1957)

ggplot(gapminder.1957,aes(x=gdpPercap, y=lifeExp, color=continent, size=pop)) +
  geom_point(alpha=0.7) +
  scale_size_area(max_size=15)

# 1957 and 2007
gapminder.1957.2007 <- gapminder %>% 
  filter(year==1957 | year==2007)

ggplot(gapminder.1957.2007) + 
  geom_point(aes(x = gdpPercap, y = lifeExp, color=continent, size = pop), alpha=0.7) + 
  scale_size_area(max_size = 10) +
  facet_wrap(~year)

## BAR CHARTS

gapminder_top5 <- gapminder %>% 
  filter(year==2007) %>% 
  arrange(desc(pop)) %>% 
  top_n(5, pop)

ggplot(gapminder_top5, aes(x = reorder(country, -pop), y = pop, fill = lifeExp)) + 
  geom_col(col="gray30") +
  guides(fill=FALSE)

# flip bar chart
State <- rownames(USArrests)
ggplot(USArrests) +
  aes(x=reorder(State,Murder), y=Murder) +
  geom_point() +
  geom_segment(aes(x=State, 
                   xend=State, 
                   y=0, 
                   yend=Murder), color="blue") +
  coord_flip()

## PLOT ANIMATION

library(gapminder)
library(gganimate)
library(gifski)

ggplot(gapminder, aes(gdpPercap, lifeExp, size = pop, colour = country)) +
  geom_point(alpha = 0.7, show.legend = FALSE) +
  scale_colour_manual(values = country_colors) +
  scale_size(range = c(2, 12)) +
  scale_x_log10() +
  facet_wrap(~continent) +
  labs(title = 'Year: {frame_time}', x = 'GDP per capita', y = 'life expectancy') +
  transition_time(year) +
  shadow_wake(wake_length = 0.1, alpha = FALSE)

## COMBINING PLOTS

library(patchwork)

p1 <- ggplot(mtcars) + geom_point(aes(mpg, disp))
p2 <- ggplot(mtcars) + geom_boxplot(aes(gear, disp, group = gear))
p3 <- ggplot(mtcars) + geom_smooth(aes(disp, qsec))
p4 <- ggplot(mtcars) + geom_bar(aes(carb))

(p1 | p2 | p3) /
  p4