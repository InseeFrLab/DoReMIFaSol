#' @export

print.insee_data_frame <- function(x, ...) {

  print.data.frame(x, ...)
  
  cat(
    "+--------------------------------------------------------------------------------+\n",
    "| Source : ",  attr(x, "source")$producteur, "\n",
    "|   * url : ", attr(x, "source")$url, "\n",
    "|   * info diffusion : ", attr(x, "source")$infos_diffusion, "\n",
    "+--------------------------------------------------------------------------------+\n",
    sep = ""
  )

}
