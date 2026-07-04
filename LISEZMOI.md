---
Type: Doc
Use: Fichier LISEZMOI pour le dépôt GitHub de projets divers.
Tags: !!str "#lisezmoi #projets #github"
Creation: 2026-06-22
Update: 2026-07-02
Contributors: [神縁]
---

[English version](README.md)

# Projets Divers
================================================================================

-------------------------
## Description
-------------------------

Ce dépôt a pour but de présenter divers extraits de code ou travaux sur lesquels je travaille actuellement, et d'en décrire l'objectif et le sens dans cette introduction du LISEZMOI.

-------------------------
## Projets
-------------------------

---
### Classe VBA Stringbuilder
###

[Stringbuilder](cStringBuilder.cls)

Cet objet sort de ma bibliothèque de fonctions habituelle. Il est généralement inclus directement dans la bibliothèque que j'ai développée, car son usage est vraiment important dans les manipulations SQL sous Access, par exemple.
Je présente ici une classe séparée, sans pile d'erreurs et sans utilisation des fonctions natives de la *bibliothèque*, afin de la faire fonctionner en singleton ou de la simplifier de quelque manière que ce soit.

#### Illustration des conventions de formatage

J'ai déposé ceci ici pour donner une idée de la façon dont je codais en VBA autrefois et de la manière dont je structurais mes classes.
Il y aurait beaucoup plus à dire, car la *bibliothèque* complète que j'installais au début de chaque projet comportait en plus une gestion d'erreurs avec pile d'appels de fonctions et marqueurs de ligne, des sorties uniques et des ramasse-miettes évolués...
Je publierai peut-être des directives sur le formatage VBA et sur des notations hongroises visuellement efficaces. Cela semble peu nécessaire, car l'usage d'Excel et d'Access va décroissant, et donc celui de VBA aussi. Les EDI open source pour LibreOffice et OpenOffice ne rivalisent pas avec le VBA d'origine associé à MZTools3VBA.
Il y avait déjà quelques limitations de VBA vraiment agaçantes (comme le fait qu'*option base 1* ne s'appliquait pas partout une fois définie, par exemple: si je me souviens bien, les tableaux et les appels API ne l'utilisaient pas systematiquement malgré une option explicitement definie). L'indexation en base 0 des développeurs est vraiment un tic de codeur qui perd son sens dans la pensée réelle. Elle n'est efficace que pour stocker des données fantômes telles que des noms d'objets, des pointeurs et des en-têtes, choses utiles mais non affichées.

#### Utilité

Cet extrait s'est révélé extrêmement utile pour résoudre mon tout premier vrai problème professionnel: réduire le coût du chargement des pages pour les utilisateurs.<br>
Le temps de chargement était excessivement long pour une mauvaise raison: la concaténation de chaînes à l'aide de l'opérateur `&`. À chaque opération, une nouvelle chaîne est créée, et les temps d'allocation mémoire et de ramasse-miettes s'accumulent au fil des itérations.
L'utilisation de la fonction native `$mid` résout ce problème de façon très astucieuse. Plutôt que de créer une variable de chaîne ne contenant que le texte à écrire, cela crée un espace beaucoup plus grand, prêt à accueillir davantage de texte, en remplaçant des caractères vides et en conservant la trace de l'emplacement réel de la chaîne. Des caractères vides restent disponibles tout à la fin pour de nouvelles concaténations. La taille du tampon (chaîne de tête et espaces de fin) augmente de façon exponentielle en doublant à chaque fois que nécessaire. Ainsi, en l'espace de 10 concaténations avec `&` (initiale comprise), on peut concaténer jusqu'à $34*2^9=17\,408$ caractères, 34 étant le nombre de caractères de la taille initiale du tampon.

#### Amélioration

Alors que je travaillais sur l'accélération de calculs de masques de bits, j'ai trouvé un petit extrait de code permettant d'améliorer le calcul des puissances de 2. Plutôt que de laisser l'ordinateur effectuer un calcul par force brute (ce qui revient à peu près à itérer des multiplications), il est possible d'utiliser la forme binaire et simplement d'écrire un 1 un niveau au-dessus du 1 de tête, suivi de zéros...
Puissance de 2 instantanée pour l'optimisation.

#### Étude

Ce code est intéressant pour deux raisons:
- D'abord, la technique d'expansion de taille de tableau par incréments de tampon en puissances de deux, qui permettra d'économiser une quantité considérable de calculs dans d'autres domaines.
- Le calcul des puissances de 2 par masque de bits est également une astuce ingénieuse pour gagner en efficacité de calcul.

---
### TSLST
###

TSLST signifie **Traced Source Licensing Standard Terminology** (Terminologie Standard de Licence à Source Tracée). Alors que l'analyse et le développement agentiques prennent une importance croissante dans l'expansion actuelle du web, la licence MIT ne comportait pas deux caractéristiques que cette licence entend apporter:
- Garantir la **responsabilité** des agents: les agents IA en sont à leurs balbutiements, tout ce qu'ils produisent relève de la responsabilité de quelqu'un.
- La **traçabilité** des idées: créditer la source, à la fois de manière **légale** et en tant que **norme communautaire**, peut permettre de cartographier les **influences** des orientations positives du développement, d'accorder un peu de **crédit** informel aux concepteurs et de faire le lien avec des implémentations similaires. Cela est difficile à visualiser pour l'instant, mais cela ne fera que s'étendre progressivement avec le temps, à mesure que les données seront traitées à plus grande échelle.

Spirituellement, je suis tout à fait favorable aux biens communs partagés et au partage de connaissances ; TSLST est une tentative de conserver la permissivité et l'ouverture du code source tout en garantissant de bonnes pratiques et des recours légaux en cas d'usage abusif. TSLST ne peut être utilisée que sur des projets suffisamment éloignés de l'influence initiale pour annuler les licences MIT précédentes ; elle sera principalement utilisée sur des choses que j'ai développées à partir de zéro.

[LICENCE](manifesto_tslst)

---
### Git et liens symboliques
###

J'ai tendance à utiliser des liens symboliques pour accéder au même fichier depuis différents points $-$ ce qui est particulièrement utile si le fichier est utilisé dans plusieurs projets $-$ cela me permet de centraliser les documents.
Le problème, c'est que Git ne gère pas correctement les liens symboliques et ne télécharge sur GitHub que le lien symbolique plutôt que le fichier original.
J'ai donc créé un petit script Bash pour résoudre ce problème de manière élégante.
Dans `.bash_aliases`:
```bash
alias gsc='git_symlink_commit.sh'
```
Utilisation:
```bash
cd /git/folder
gsc "MESSAGE_DE_COMMIT"
```

[Symlink commits](git_symlink_commit.sh)

-------------------------
## À venir
-------------------------

Je publierai peut-être un ou deux PRD, quelques scripts Python que j'utilise actuellement pendant que je travaille sur une boîte à outils personnelle complète, des scripts de harnais pour LLM local sur du matériel ancien et à coût nul, des articles sur différents sujets sur lesquels je travaille $-$ comme l'application de l'IA à des environnements simulés: un environnement 3D simulé comme Quake 3 serait la prochaine étape de l'IA à déployer, les bots à logique floue étant désormais dépassés (mais je dois d'abord maîtriser son code source et mettre en place la stéréographie).

***