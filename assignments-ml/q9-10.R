options(scipen=999)

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

# ANOVA
# Only animacy as the input factor
animacy_fit <- aov(dissimilarity ~ animacy, data = data_frame)
animacy_fit <- lm(dissimilarity ~ animacy, data = data_frame)
summary(animacy_fit)

# Only faceness as the input factor
faceness_fit <- aov(dissimilarity ~ faceness, data = data_frame)
faceness_fit <- lm(dissimilarity ~ faceness, data = data_frame)
summary(faceness_fit)

# Question 10
# Relative effect sizes for these two effects

# Animacy, faceness and their interaction as the input factors
cov(data_frame)

combined_fit <- lm(dissimilarity ~ animacy * faceness, data = data_frame)
summary(combined_fit)

