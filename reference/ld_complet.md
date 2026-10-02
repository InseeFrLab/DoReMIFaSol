# Charge le catalogue complet (statique + Melodi) de manière lazy

À la première utilisation, récupère le catalogue Melodi depuis le SSP
Cloud et le fusionne avec le catalogue statique empaqueté dans le
package. Le résultat est mis en cache pour les appels suivants.

## Usage

``` r
ld_complet()
```

## Value

un objet list (le catalogue complet)
