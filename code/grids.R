## Load Libraries
library(magick)
library(gridExtra)

## File Loading
myfiles <- file.path("~/Downloads/NewImg", dir("~/Downloads/NewImg/"))
image_count <- length(myfiles)

## Configuration
columns <- 10
rows <- ceiling(image_count / columns)
left_margin <- 250
a4_ratio <- 842 / 595 # height / width

## Read in each image
for (i in 1:image_count) {
    assign(paste0("im", i), image_read(myfiles[i]))
}

## Get One Image Dimension
imwidth <- image_info(im1)$width
imheight <- image_info(im1)$height

## Fix the height, increase the width
fixed_width <- FALSE
canvas <- c(imwidth * columns + left_margin,
            imheight * rows)
a4_canvas <- c(canvas[1], round(a4_ratio * canvas[1]))
diff <- -1 * round((canvas[2] - a4_canvas[2]) / 2)

## Fix the width, increase the height
if (diff < 0) {
    fixed_width <- TRUE
    a4_canvas <- c(round(a4_ratio * canvas[2]), canvas[2])
    diff <- round((canvas[1] - a4_canvas[1]) / 2)
}

## Crop each image
#for (i in 1:image_count) {
#    myimg <- get(paste0("im", i))
#    
#    geometry <- paste0(image_info(myimg)$width, "x", image_info(myimg)$height - height_diff_perimg, "+", 0, "-", height_diff_perimg)
#    
#    assign(paste0("im", i), image_crop(myimg, geometry = geometry))
#}

## Get the grid of images to go in each column
final_img <- im1
mygrid <- sapply(c(1:(columns - 1), 0), function(col) { 
    (1:image_count)[1:image_count %% columns == col]
}, simplify = FALSE)

## Create a column vector for each column
image_grid <- lapply(mygrid, function(inds) {
    final_img <- get(paste0("im", inds[1]))
    for (i in 2:length(inds)) {
        final_img <- image_append(c(final_img, get(paste0("im", inds[i]))), stack = TRUE)
    }
    
    return(final_img)
})

## Combine the column image vectors into one single image
result_img <- image_grid[[1]]
for (i in 2:length(image_grid)) {
    result_img <- image_append(c(result_img, image_grid[[i]]))
}

## Add left margin to the left
result_img <- result_img %>%
    image_border("white", paste0(left_margin, "x0")) %>%
    image_crop(paste0(image_info(result_img)$width + left_margin, "x", 
                      image_info(result_img)$height))

## Add a border to make a4 size
if (!fixed_width) {
    result_img <- result_img %>%
        image_border("white", paste0("0x", diff))
} else {
    result_img <- result_img %>%
        image_border("white", paste0(diff, "x0"))
}

## Show image
result_img

## Write the resulting image
image_write(result_img, path = "test.png", format = "png")
