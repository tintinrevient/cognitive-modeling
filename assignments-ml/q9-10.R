library(lsr)
# options(scipen=999)

categoryVectorsTable <- read.table("RSAlabassignment/CategoryVectors")
categoryLablesTable <- read.table("RSAlabassignment/CategoryLabels")
neuralResponses <- read.table("RSAlabassignment/NeuralResponses")

# Question 9
# Effect of both animacy and face-ness on dissimilarity

# animacy RDM: 92x92
row = 92
col = 92
animacy_rdm_source <- matrix(0, nrow = row, ncol = col)

for(i in 1:row) {
  for(j in 1:col) {
    if(categoryVectorsTable[i,1] == categoryVectorsTable[j,1]) {
      animacy_rdm_source[i, j] = 1
    } else {
      animacy_rdm_source[i, j] = 0
    }
  }
}

# Retrieve the non-duplicate data from the lower triangle of RDM without the diagonal data
animacy_rdm_lower_triangle_filter <- lower.tri(animacy_rdm_source, diag = FALSE)
animacy_rdm_unique <- animacy_rdm_source[animacy_rdm_lower_triangle_filter]

# Retrieve the non-duplicate data for the neural responses
neuralResponses_source <- 1 - cor(t(neuralResponses))
neuralResponses_lower_triangle_filter <- lower.tri(neuralResponses_source, diag = FALSE)
neuralResponses_unique <- neuralResponses_source[neuralResponses_lower_triangle_filter]

# data frame of the same & different animacy
data_frame <- cbind(neuralResponses_unique, animacy_rdm_unique)

# face-ness RDM: 92x92
row = 48
col = 48
faceness_rdm_source <- matrix(0, nrow = row, ncol = col)

for(i in 1:row) {
  for(j in 1:col) {
    if(categoryVectorsTable[i,6] == categoryVectorsTable[j,6]) {
      faceness_rdm_source[i, j] = 1
    } else {
      faceness_rdm_source[i, j] = 0
    }
  }
}

faceness_rdm_source <- rbind(faceness_rdm_source, matrix(0, nrow = 44, ncol = 48))
faceness_rdm_source <- cbind(faceness_rdm_source, matrix(0, nrow = 92, ncol = 44))

# Retrieve the non-duplicate data from the lower triangle of RDM without the diagonal data
faceness_rdm_lower_triangle_filter <- lower.tri(faceness_rdm_source, diag = FALSE)
faceness_rdm_unique <- faceness_rdm_source[faceness_rdm_lower_triangle_filter]

# data frame of the same & different face-ness
data_frame <- cbind(data_frame, faceness_rdm_unique)

# Transform to data frame
data_frame <- as.tibble(data_frame)
data_frame <- data_frame %>% rename(dissimilarity = neuralResponses_unique, 
                                    animacy = animacy_rdm_unique,
                                    faceness = faceness_rdm_unique)

View(data_frame)

library(car)
# ANOVA
data_frame$animacy <- factor(data_frame$animacy)
data_frame$faceness <- factor(data_frame$faceness) 
fit <- aov(dissimilarity ~ animacy + animacy:faceness, data = data_frame)
summary(fit)

# eta
etaSquared(fit, type = 2, anova = TRUE)


# glm(starting ~ animacy + animacy_face)
model <- glm(dissimilarity ~ animacy + animacy:faceness, data = data_frame)
summary(model)

# beta 
library(reghelper)
beta(model, x = TRUE, y = TRUE)


# f-test manually
animacy_only_data_frame <- data_frame[(which(data_frame$animacy == 1)),]
faceness_only_data_frame <- data_frame[(which(data_frame$faceness == 1)), ]

df_animacy <- nrow(animacy_only_data_frame) - 1
df_faceness <- nrow(faceness_only_data_frame) - 1
critical_value <- 1.12

variance_animacy <- var(animacy_only_data_frame$dissimilarity)
variance_faceness <- var(faceness_only_data_frame$dissimilarity)

# if f_ratio is greater than the critical value, we reject the null hypothesis:
# null hypothesis: variances are equal
# alternative hypothesis: variances are not equal
f_ratio <- variance_faceness / variance_animacy

# anova manually

total_mean <- mean(data_frame$dissimilarity)
animacy_mean <- mean(animacy_only_data_frame$dissimilarity)
faceness_mean <- mean(faceness_only_data_frame$dissimilarity)

animacy_variance_between <- total_mean - animacy_mean
faceness_variance_between <- total_mean - faceness_mean

animacy_variance_within <- max(animacy_only_data_frame$dissimilarity) - 
  min(animacy_only_data_frame$dissimilarity)

faceness_variance_within <- max(faceness_only_data_frame$dissimilarity) - 
  min(faceness_only_data_frame$dissimilarity)

# f value is larger than 1, reject null hypothesis H0
# null hypothesis: means are equal, and samples come from the same population
# alternative hypothesis: means are not equal, and samples come from different population
f_animacy <- animacy_variance_between / animacy_variance_within
f_faceness <- faceness_variance_between / faceness_variance_within

# Question 10
# Relative effect sizes for these two effects

# Animacy, faceness and their interaction as the input factors
cov(data_frame)

combined_fit <- lm(dissimilarity ~ animacy * faceness, data = data_frame)
summary(combined_fit)

