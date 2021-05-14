#' @title Genome-wide association analysis (GWAS) using PLINK 
#' 
#' @description Performs GWAS using PLINK using shell command lines
#' 
#' @param client \code{ssh} SSH resource or Shell resource
#' @param ... \code{character vector} Arguments to pass to the PLINK software
#' 
#' @author Gonzalez, JR.
#'
#' @import readr
#'
#' @export 
#' 
plinkDS <- function(client, ...){
  
  dots <- list(...)

  if (! any(c('ShellResourceClient', 'SshResourceClient') %in% class(client))) {
    stop("Resource need to be either 'ShellResourceClient' or 'SshResourceClient'", call. = FALSE)
  }
  
  dashedNames <- unlist(lapply(names(dots), function(n) {
    paste0("--", n)
  }))

  plink.command <- gsub("-- ", "--", paste(dashedNames, dots, collapse = " ", sep=" "))
  plink.command <- unlist(strsplit(plink.command, " "))
  
  plink.command <- c(plink.command, "--noweb", "--out")
  if ('ShellResourceClient' %in% class(client)) {
    tempDir <- base::tempdir()
  }
  else {
    tempDir <- client$tempDir()
  }
  command <- c(plink.command, paste0(tempDir, '/out'))
  
  plink <- client$exec('plink1', command)
  
  if ('ShellResourceClient' %in% class(client)) {
    client$copyFile(paste0(tempDir, '/out.*'), to = base::getwd())
  }
  else {
    client$downloadFile(paste0(tempDir, '/out.*'))
  }
  
  outs <- client$exec('ls', tempDir)$output
  outs <- outs[-grep(".hh$|.log$|.nof$", outs)]

  if (length(outs)==0){
    ans <- plink$error
  }
  else {
    if (length(outs)==1) {
      print('====')
      print(outs)
      print(getwd())
      print('====')
      results <- readr::read_table(outs)
      }
    else {
      results <- c("There are more than 1 table as output")
    }
    ans <- list(results=results, plink.out = plink)
  }
    
  if ('ShellResourceClient' %in% class(client)) {
    print('----')
    print(tempDir)
    print('----')
#    base::unlink(tempDir, recursive=TRUE)
  }
  else {
    client$removeTempDir()
  }
  client$close()
  
  return(ans)
}
