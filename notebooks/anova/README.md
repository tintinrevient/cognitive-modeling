# Analysis of Variance

## Overview

**Regression**: 
* predict a quantitative response variable from quantitative predictor variables
* special cases of the general linear model

**ANOVA (Analysis of Variance)**:
* include norminal or ordinal factors as predictors
* shift from predicting to understanding group differences
* special cases of the general linear model
* effects in ANOVA designs are primarily evaluated by **F tests**
* if the F test for a factor is significant (**p < 0.0001**), the **mean** response scores differ


## Keywords

**between-groups factor with two levels**: e.g. 2 treatment methods for 2 groups

**within-groups factor with two levels** = **repeated measures**: e.g. each patient is measured under two levels (five weeks, six months)

**confounding factor** = **nuisance variable** = **covariate**: e.g. post-therapy differences might be due to preexisting depression differences and not to your experimental manipulation

**independent variable**: predictor variable = factor

**dependent variable**: response variable

**a balanced design**: an equal number of observations in each treatment condition

**an unbalanced design**: the sample sizes are unequal

**one-way ANOVA**: a single classification/predictor variable

**two-way ANOVA** = **factorial ANOVA design**: two predictor variables/factors are included 
* **main effect**: the effect caused by factors
* **interaction effect**: the effect caused by the interaction of factors

**mixed-model ANOVA**: a factorial ANOVA design includes both between-groups and within-groups factors

**ANCOVA (Analysis of Covariance)**: if covariate exists in ANOVA design

**MANOVA (Multivariate Analysis of Variance)**: if there is more than one dependent variable

**MANCOVA (Multivariate Analysis of Covariance)**: if there is more than one dependent variable and covariate exists


## The aov() function

aov(formula, data = dataframe)
* response variable ~ predictor variable: e.g. y ~ A + B + C
* A:B denotes the interaction between variables: e.g. y ~ A + B + A:B
* A * B * C denotes the complete crossing variables: e.g. A * B * C = A + B + C + A:B + B:C + A:C + A:B:C
* (A + B + C)^2 denotes the crossing to a specified degree: e.g. (A + B + C)^2 = A + B + C + A:B + B:C + A:C

Formulas for common research designs:
* One-way ANOVA: y ~ A
* One-way ANCOVA with 1 covariate: y ~ x + A
* Two-way factorial ANOVA: y ~ A * B
* Two-way factorial ANCOVA with 2 covariates: y ~ x1 + x2 + A * B
* One-way within-groups ANOVA: y ~ A + Error(Subject/A)
* Repeated measures ANOVA with 1 within-groups factor (W) and 1 between-groups factor (B): y ~ B * W + Error(Subject/W)

**aov() function uses the Type I approach**

## ANOVA effects

**Type I (Sequential)**:
* effects are adjusted for those that appear earlier in the formula
* y ~ A + B + A:B 
	* A is unadjusted, B is adjusted for A, A:B interaction is adjusted for A and B
	* the impact of A on y, the impact of B on y controlling for A, the interaction of A and B on y controlling for the A and B main effects

**Type II (Hierarchical)**:
* effects are adjusted for those at the same or lower level
* y ~ A + B + A:B
	* A is adjusted for B, B is adjusted for A, A:B interaction is adjusted for A and B


**Type III (Marginal)**:
* effects are adjusted for each other
* y ~ A + B + A:B
	* A is adjusted for B and A:B, B is adjusted for A and A:B, A:B interaction is adjusted for A and B

**the greater the imbalance in sample sizes, the greater the impact that the order of terms will have on the results**

**confidence in results depends on the degree to which your data satisfies the assumptions underlying the statistical tests**

## Sample code

### One-way ANOVA

```
library(multcomp)

attach(cholesterol) #data
table(trt)

aggregate(response, by = list(trt), FUN = mean)
aggregate(response, by = list(trt), FUN = sd)

fit <- aov(response ~ trt)
summary(fit)

library(gplots)
plotmeans(response ~ trt, xlab = "Treatment", ylab = "Response", main = "Mean Plot\nwith 95% CI")

# Tukey HSD pairwise group comparison
TukeyHSD(fit)

fit2 <- lm(response ~ trt, data = cholesterol)
summary(fit2)

detach(cholesterol)
```

<p float="left">
	<img src="./cholesterol.png" width="500" />
</p>

**One-way ANOVA assumption**: 
* the dependent variable is **normally distributed**
* **the variance is equal** in each group 

**Q-Q Plot**:
```
library(car)

qqPlot(lm(response ~ trt, data = cholesterol), 
       simulate = TRUE, 
       main = "Q - Q Plot", 
       labels = FALSE)
```

**normality assumption has been met**:
* the data falls within the 95% confidence envelope
<p float="left">
	<img src="./qq-plot.png" width="500" />
</p>

**Bartlett's test**
```
bartlett.test(response ~ trt, data = cholesterol)
```

**equality of variance (homogeneity) has been met**:
* the variances in the five groups don't differ significantly (p = 0.97)
```
	Bartlett test of homogeneity of variances

data:  response by trt
Bartlett's K-squared = 0.57975, df = 4, p-value = 0.9653
```

**The outlierTest() function**
```
library(car)

outlierTest(fit)
```

**no indication of outliers in the cholesterol data**
* NA occurs when p > 1
* analysis of variance methodologies can be sensitive to the presence of outliers
```
No Studentized residuals with Bonferroni p < 0.05
Largest |rstudent|:
   rstudent unadjusted p-value Bonferroni p
19 2.251149           0.029422           NA
```

### One-way ANCOVA

```
library(multcomp)

attach(litter) #data
table(dose)

aggregate(weight, by = list(dose), FUN = mean)

fit <- aov(weight ~ gesttime + dose)
summary(fit)
```

**ANCOVA F test**:
* gestation time was related to birth weight
* drug dosage was related to birth weight, after controlling for gestation time
* the mean birth weight wasn't the same for each of the drug dosages, after controlling for gestation time
```
            Df Sum Sq Mean Sq F value  Pr(>F)   
gesttime     1  134.3  134.30   8.049 0.00597 **
dose         3  137.1   45.71   2.739 0.04988 * 
Residuals   69 1151.3   16.69                   
---
Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1
```

**The effects() function**
* calculate the adjusted means
* adjusted means = group means obtained after **partialing out the effects of the covariate**

```
library(effects)

effect("dose", fit)
```

**the adjusted means are similar to the unadjusted means produced by the aggregate() function**
```
 dose effect
dose
       0        5       50      500 
32.35367 28.87672 30.56614 29.33460 
```

**One-way ANCOVA assumption**: 
* the dependent variable is **normally distributed**
* **the variance is equal** in each group
* homogeneity of **regression slope**

```
library(multcomp)

fit2 <- aov(weight ~ gesttime * dose, data = litter)
summary(fit2)
```

**ANCOVA F test**:
* a significant interaction would imply that the relationship between gestation and birth weight depends on the level of the dose variable
* below data suggests that the interaction is nonsignificant
* so the regression slope for predicting birth weight from gestation time is **the same** in each of the four treatment groups
```
              Df Sum Sq Mean Sq F value  Pr(>F)   
gesttime       1  134.3  134.30   8.289 0.00537 **
dose           3  137.1   45.71   2.821 0.04556 * 
gesttime:dose  3   81.9   27.29   1.684 0.17889   
Residuals     66 1069.4   16.20                   
---
Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1
```

**The ancova() function**

```
library(HH)

ancova(weight ~ gesttime + dose, data = litter)
```

<p float="left">
	<img src="./ancova.png" width="600" />
</p>

### Two-way ANOVA

```
attach(ToothGrowth)
table(supp, dose)

aggregate(len, by = list(supp, dose), FUN = mean)
aggregate(len, by = list(supp, dose), FUN = sd)

dose <- factor(dose)

fit <- (len ~ supp * dose)
summary(fit)
```

**display the interaction in a two-way ANOVA**:
* main effects (supp and dose) are significant
* interaction effect between supp and dose is significant

```
library(HH)

interaction2wt(len ~ supp * dose)
```

<p float="left">
	<img src="./interaction2wt.png" width="600" />
</p>

### Repeated measures ANOVA

```
CO2$conc <- factor(CO2$conc)
w1b1 <- subset(CO2, Treatment == "chilled")

fit <- aov(uptake ~ conc * Type + Error(Plant/(conc)), w1b1)
summary(fit)


# interaction plot
par(las = 2)
par(mar = c(10, 4, 4, 2))
with(w1b1, interaction.plot(conc, Type, uptake, 
                            type = "b",
                            col = c("red", "blue"),
                            pch = c(16, 18),
                            main = "Interaction Plot for Plant Type and Concentration"))
```

**ANOVA F test**:
* the Type and concentration main effects are significant at the 0.01 level
* the Type and concentration interaction effect is significant at the 0.01 level
* the difference between Quebec and Mississippi is more pronounced at higher ambient CO2 concentrations
<p float="left">
	<img src="./repeated-measures.png" width="500" />
</p>

**when dealing with repeated measures ANOVA, you typically need the data in long format before fitting models**

### One-way MANOVA

```
library(MASS)
attach(UScereal)

shelf <- factor(shelf)
y <- cbind(calories, fat, sugars)

aggregate(y, by = list(shelf), FUN = mean)
cov(y)

fit <- manova(y ~ shelf)
summary(fit)
summary.aov(fit)
```

**The cov() function provides the variance and covariances across cereals**
