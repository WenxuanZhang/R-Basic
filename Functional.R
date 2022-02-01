# Functional R

library(purrr)

triple <- function(x) x * 3
map(1:3, triple)

#a example simple_map
simple_map <- function(x, f, ...) {
  out <- vector("list", length(x))
  for (i in seq_along(x)) {
    out[[i]] <- f(x[[i]], ...)
  }
  out
}

map_chr(mtcars, typeof)
map_lgl(mtcars, is.double)
n_unique <- function(x) length(unique(x))
map_int(mtcars, n_unique)

#All map functions always return an output vector the same length as the input, 
#which implies that each call to .f must return a single value. 
#If it does not, you’ll get an error:

map(1:2, pair)
map(1:2, as.character)


map_dbl(mtcars, function(x) length(unique(x)))
map_dbl(mtcars, ~ length(unique(.x)))

x <- map(1:3, ~ runif(2))

x <- list(
  list(-1, x = 1, y = c(2), z = "a"),
  list(-2, x = 4, y = c(5, 6), z = "b"),
  list(-3, x = 8, y = c(9, 10, 11))
)

map_dbl(x, "x")
map_dbl(x, 1)
map_dbl(x, list("y", 1))
map_chr(x, "z", .default = NA)


x <- list(1:5, c(1:10, NA))
map_dbl(x, ~ mean(.x, na.rm = TRUE))
#> [1] 3.0 5.5


map_dbl(x, mean, na.rm = TRUE)
#> [1] 3.0 5.5



plus <- function(x, y) x + y

x <- c(0, 0, 0, 0)
map_dbl(x, plus, runif(1))
#> [1] 0.0625 0.0625 0.0625 0.0625
map_dbl(x, ~ plus(.x, runif(1)))
#> [1] 0.903 0.132 0.629 0.945


trims <- c(0, 0.1, 0.2, 0.5)
x <- rcauchy(1000)
map_dbl(trims, function(trim) mean(x, trim = trim))

# The code 
trials <- map(1:100, ~ t.test(rpois(10, 10), rpois(7, 10)))

#map
formulas <- list(
  mpg ~ disp,
  mpg ~ I(1 / disp),
  mpg ~ disp + wt,
  mpg ~ I(1 / disp) + wt
)

map(formulas,~lm(data=mtcars))

bootstrap <- function(df) {
  df[sample(nrow(df), replace = TRUE), , drop = FALSE]
}

bootstraps <- map(1:10, ~ bootstrap(mtcars))


by_cyl <- split(mtcars, mtcars$cyl)
by_cyl %>% 
  map(~ lm(mpg ~ wt, data = .x)) %>% 
  map(coef) %>% 
  map_dbl(2)

map_lgl(mtcars,is.numeric)


df <- data.frame(
  x = 1:3,
  y = 6:4
)

map(df, ~ .x * 2)

modify(df, ~ .x * 2)


xs <- map(1:8, ~ runif(10))
xs[[1]][[1]] <- NA
ws <- map(1:8, ~ rpois(10, 5) + 1)

map_dbl(xs, mean)

map_dbl(xs, weighted.mean, w = ws)


map2_dbl(xs, ws, weighted.mean)

map2_dbl(xs, ws, weighted.mean, na.rm = TRUE)



welcome <- function(x) {
  cat("Welcome ", x, "!\n", sep = "")
}
names <- c("Hadley", "Jenny")


map(names, welcome)

walk(names, welcome)


temp <- tempfile()
dir.create(temp)

cyls <- split(mtcars, mtcars$cyl)
paths <- file.path(temp, paste0("cyl-", names(cyls), ".csv"))
walk2(cyls, paths, write.csv)

dir(temp)
#> [1] "cyl-4.csv" "cyl-6.csv" "cyl-8.csv"


x <- map(1:6, ~ sample(1000, 10))
imap_chr(x, ~ paste0("The highest value of ", .y, " is ", max(.x)))


pmap_dbl(list(xs, ws), weighted.mean)
pmap_dbl(list(xs, ws), weighted.mean, na.rm = TRUE)


trims <- c(0, 0.1, 0.2, 0.5)
x <- rcauchy(1000)

pmap_dbl(list(trim = trims), mean, x = x)
#> [1] -6.6740  0.0210  0.0235  0.0151

params <- tibble::tribble(
  ~ n, ~ min, ~ max,
  1L,     0,     1,
  2L,    10,   100,
  3L,   100,  1000
)

pmap(params, runif)


trans <- list(
  disp = function(x) x * 0.0163871,
  am = function(x) factor(x, labels = c("auto", "manual"))
)

nm <- names(trans)
mtcars[nm] <- map2(trans, mtcars[nm], function(f, var) f(var))

l <- map(1:4, ~ sample(1:10, 15, replace = T))
str(l)


out <- l[[1]]
out <- intersect(out, l[[2]])
out <- intersect(out, l[[3]])
out <- intersect(out, l[[4]])
out

reduce(l, intersect)

reduce(l, union)


x <- c(4, 3, 10)
reduce(x, `+`)

accumulate(x, `+`)


df <- data.frame(
  num1 = c(0, 10, 20),
  num2 = c(5, 6, 7),
  chr1 = c("a", "b", "c"),
  stringsAsFactors = FALSE
)

str(map_if(df, is.numeric, mean))
#> List of 3
#>  $ num1: num 10
#>  $ num2: num 6
#>  $ chr1: chr [1:3] "a" "b" "c"
str(modify_if(df, is.numeric, mean))
#> 'data.frame':    3 obs. of  3 variables:
#>  $ num1: num  10 10 10
#>  $ num2: num  6 6 6
#>  $ chr1: chr  "a" "b" "c"
str(map(keep(df, is.numeric), mean))
#> List of 2

