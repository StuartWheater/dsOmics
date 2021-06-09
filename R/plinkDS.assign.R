#' @title Genome-wide association analysis (GWAS) using PLINK, as an assgn style operation. 
#' 
#' @description Performs GWAS using PLINK using shell command lines. This is achived
#' using the plinkDS agragate function.
#' 
#' @param client \code{ssh} SSH resource or Shell resource
#' @param ... \code{character vector} Arguments to pass to the PLINK software
#' 
#' @author Wheater, Stuart.
#'
#' @export 
#' 
plinkDS.assign <- function(client, ...)
{
  
  return(plinkDS(client, ...))
}
