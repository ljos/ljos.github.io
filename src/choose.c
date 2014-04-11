
#include <SWI-Prolog.h>
#include <gmp.h>

static foreign_t                                                    
pl_choose(term_t size, term_t take, term_t result)                   
{
  mpz_t rop;                                                         
  mpz_t n;
  unsigned long int k;
  int rc;

  mpz_init(rop);                                                     
  mpz_init(n);

  if ( PL_get_mpz(take, rop) && PL_get_mpz(size, n) )                
    {
      k = mpz_get_ui(rop);                                             
      mpz_bin_ui(rop, n, k);                                     
      rc = PL_unify_mpz(result, rop);                               
    }
  else
    {
      rc = FALSE;                                                    
    }

  mpz_clear(rop);                                                   
  mpz_clear(n);
  return rc;                                                       
}

install_t
install_choose()                                                  
{
  PL_register_foreign("choose", 3, pl_choose, 0);
}
