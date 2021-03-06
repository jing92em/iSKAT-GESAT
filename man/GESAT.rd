 \name{GESAT}
 \alias{GESAT}
 \alias{GESAT.SSD.OneSet}
 \alias{GESAT.SSD.OneSet_SetIndex}
 \title{Gene-Environment Set Association Test}
 \description{
     Test for interactions between a set of SNPS/genes and Environment. 
     GESAT/iSKAT tests for ZxE (gene-environment interactions), after accounting for main effects of Z (gene), main effects of E (environment) and X (covariates).
     If the appropriate arguments are set (i.e. same scale.Z, weights.Z, weights.V, MAF_cutoff), iSKAT with r.corr=0 corresponds to GESAT.
     Note that the default function values for GESAT() and iSKAT() can be different.
     Warning: Current implementation of GESAT/iSKAT assumes large sample asymptotics. We do not recommend using GESAT/iSKAT for SNP-sets where p/n > 1/3 where p and n are defined as below.  
 }
 \references{
  Lin, X., Lee, S., Christiani, D. C., and Lin, X. (2013). Test for the Interaction between a Genetic Marker Set and Environment in Generalized Linear Models. Biostatistics, 14: 667-681. doi:10.1093/biostatistics/kxt006.
 }
 \usage{

GESAT(Z, Y, E, X=NULL, type="davies",
        lower=1e-20, upper=sqrt(nrow(Y))/log(nrow(Y)), nintervals=5, 
        plotGCV=FALSE, plotfile=NA, scale.Z=TRUE, weights.Z=NULL, 
        weights.V=NULL, out_type="C", impute.method = "fixed", 
        is_check_genotype=TRUE, is_dosage=FALSE, missing_cutoff=0.15, 
        SetID=NULL)
        
GESAT.SSD.OneSet(SSD.INFO, SetID, \dots)

GESAT.SSD.OneSet_SetIndex(SSD.INFO, SetIndex, \dots )

 }
\arguments{
      \item{Z}{a n x p numeric genotype matrix with each row as a different individual and each column as a separate gene/snp. Each genotype should be coded as 0, 1, 2, and 9 (or NA) for AA, Aa, aa, and missing, where A is a major allele and a is a minor allele. Missing genotypes will be imputed by the simple Hardy-Weinberg equilibrium (HWE) based imputation. }
      \item{Y}{a n x 1 matrix of the phenotype.  Cannot contain missing values.}
      \item{E}{a n x r numeric environmental matrix with each row as a different individual and each column as an environmental variable. Cannot contain missing values. If the environmental variable is categorical or non-numerical, it has to be recoded into a numeric variable.}
      \item{X}{a n x q numeric covariates matrix with each row as a different individual and each column as a covariate (default=NULL). Cannot contain missing values. X should not include an intercept. X should not include the variables in E.}
      \item{type}{a method to compute the p-value (default= "davies"). 
      "davies" represents an exact method that  computes the p-value by inverting the characteristic function of the mixture chisq, 
      "liu" represents an approximation method that matches the first 3 moments.}
      \item{lower}{a scalar for the lower bound of the tuning parameter (default=1e-20). lower has to be positive and <= upper. }      
      \item{upper}{a scalar for the upper bound of the tuning parameter (default=sqrt(nrow(Y))/log(nrow(Y))). upper has to be positive and >= lower. } 
      \item{nintervals}{a scalar for the number of tuning parameters to search over (default=5). resulting possible tuning parameters are c(exp(seq(log(lower),log(upper), length=nintervals))). Computation time depends on nintervals.}      
      \item{plotGCV}{TRUE/FALSE (default=FALSE). whether or not to plot the GCV tuning parameter. default=FALSE.} 
      \item{plotfile}{filename to save the GCV plot (default=NA). must have a .pdf extension. plotfile is ignored if plotGCV=FALSE.}       
      \item{scale.Z}{TRUE/FALSE (default=TRUE). whether or not to scale Z matrix to mean zero and unit variance before applying ridge penalty when adjusting for main effects of Z. If scale.Z=TRUE, weights.Z are ignored.} 
      \item{weights.Z}{a p x 1 vector of weights for Z in main effects (default=NULL). If scale.Z=TRUE, weights.Z are ignored.}         
      \item{weights.V}{a p x 1 vector of weights for Z in interaction effects (default=NULL).} 
      \item{out_type}{"C" for continuous phenotype Y and "D" for binary phenotype Y (default="C").}              
      \item{impute.method}{a method to impute missing genotypes (default= "fixed"). "random" imputes missing genotypes by generating binomial(2,p) random variables (p is the MAF), and "fixed" imputes missing genotypes by assigning the mean genotype value (2p). If you use "random", you will have different p-values for different runs because imputed values are randomly assigned. Can use set.seed() to replicate results.} 
      \item{is_check_genotype}{a logical value indicating whether to check the validity of the genotype matrix Z (default= TRUE). If you use non-SNP type data and want to run iSKAT, please set it to FALSE. If you use SNP data or imputed data, please set it to TRUE. Note that if is_check_genotype=FALSE, missing values in Z have to be coded as NA as 9 will not be treated as missing.}
      \item{is_dosage}{a logical value indicating whether the matrix Z is a dosage matrix (default= FALSE). If it is TRUE, GESAT will ignore ``is_check_genotype'' and ``impute.method'' and GESAT will check the genotype matrix and set impute.method="fixed". Note that GESAT will also treat 9 as missing in Z.}
      \item{missing_cutoff}{a cutoff of the missing rates of SNPs (default=0.15). Any SNP with missing rates higher than cutoff will be excluded from the analysis.}
      \item{SetID}{a character value of Set ID. You can find a set ID of each set from SetInfo object of SSD.INFO}
      \item{SSD.INFO}{an SSD_INFO object returned from Open_SSD. }
      \item{SetIndex}{a numeric value of Set index. You can find a set index of each set from SetInfo object of SSD.INFO  }
      \item{\dots}{furthuer arguments to be passed to ``GESAT'' }
}
\value{
	\item{pvalue}{the p-value of GESAT.}	
	\item{Is_Converge}{an indicator of the convergence. 1 indicates the method converged, and 0 indicates the method did not converge. When Is_Converge=0 (no convergence), "liu" method is used to compute p-value. Note that if method="liu", Is_converge=1 always.}  
	\item{lambda}{chosen tuning parameter.}
	\item{n.G.test}{number of SNPs in the genotype matrix used in the test. It can be different from ncol(Z) when some markers are monomorphic or have higher missing rates than the missing_cutoff. }  
	\item{n.GE.test}{number of columns in the ZxE interaction matrix used in the test. It can be different from ncol(Z)*ncol(E) when some markers are monomorphic or have higher missing rates than the missing_cutoff. It can also be different from n.G.test*ncol(E) as the resulting ZxE variable might have no variability or might be perfectly collinear with columns of Z. Note that singletons are adjusted for in the main effects but are not tested for interactions. Likewise, columns of ZxE perfectly collinear with columns of Z are not tested for interactions. }  
  \item{Error}{1= Error, 0=No Error.}
}
\details{
Data Format:
Y, E, Z, X(if not NULL) should all be matrices with the same no. of rows.
Y, E, X cannot have any missing values.
Please remove all individuals with missing Y, E, X prior to analysis (If plink files are used, these individuals have to be removed from all the plink files, e.g. prior to generating the SSD files.).
Missingness in Z is allowed and imputation will be used as described above.



SSD Files:
If you want to use the SSD file, open it first, and then use either GESAT.SSD.OneSet  or GESAT.SSD.OneSet_SetIndex. Set index is a numeric value and it is automatically assigned to each set (from 1).



Tuning Parameter: 
Upper should not be set to too large a value as if the chosen tuning parameter is too large, the main effects of Z are effectively shrunk to zero. This results in testing for ZxE without accounting for main effects of Z.                                          

}


\author{Xinyi (Cindy) Lin}



\examples{
#############################################################
# Generate data
#############################################################
set.seed(1)
n <- 1000
p <- 10
Y <- matrix(rnorm(n), ncol=1)
Z <- matrix(rbinom(n*p, 2, 0.3), nrow=n)
E <- matrix(rnorm(n))
X <- matrix(rnorm(n*2), nrow=n)
set.seed(2)
Ybinary <- matrix(rbinom(n, 1,0.5), ncol=1)


#############################################################
#	Compute the P-value of GESAT  - without covariates
#############################################################
GESAT(Z, Y, E)
GESAT(Z, Ybinary, E, out_type="D")


#############################################################
#	Compute the P-value of GESAT  - with covariates
#############################################################
GESAT(Z, Y, E, X)
GESAT(Z, Ybinary, E, X, out_type="D")
}


