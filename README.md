# Voisins de Compost est une itération de Poubelles Battle

## Contexte
[poubellesbattle.fr](https://poubellesbattle.fr) est une plateforme visant à faciliter le déploiement de composteurs collectifs en espace urbain et encourager leur utilisation.


Créé dans le contexte de [l’incubateur des startups d’état](https://beta.gouv.fr/).



## Installation pour le développement

### Dépendances techniques

#### Tous environnements

- Ruby 2.6.3
- postgresql

#### Développement

- rbenv : voir https://github.com/rbenv/rbenv-installer#rbenv-installer--doctor-scripts
- Yarn : voir https://yarnpkg.com/en/docs/install

#### Tests

- Chrome
- chromedriver :
  * Mac : `brew cask install chromedriver`
  * Linux : voir https://sites.google.com/a/chromium.org/chromedriver/downloads

### Lancement de l'application

``` bash
$ bundle install
$ rails db:migrate
$ rails db:seed
$ rails server
```

L'application tourne à l'adresse [http://localhost:3000]

### Exécution des tests (RSpec)

Les tests ont besoin de leur propre base de données et certains d'entre eux utilisent Selenium pour s'exécuter dans un navigateur. N'oubliez pas de créer la base de test et d'installer chrome et chromedriver pour exécuter tous les tests.

Pour exécuter les tests de l'application, plusieurs possibilités :

- Lancer tous les tests

```bash
$ rspec
```

- Lancer un test en particulier

```bash
$ rspec file_path/file_name_spec.rb:line_number
```

- Lancer tous les tests d'un fichier

```bash
$ rspec file_path/file_name_spec.rb
```
## Contributing

When contributing to this repository, please first make sure you follow the following git and coding conventions.

### Git Conventions

Everything is done on feature branches; everything is merged on master through pull requests; pull requests must be rebased.

### Coding Conventions

See the Ruby On Rails conventions as well as the [beta.gouv conventions](https://github.com/betagouv/beta.gouv.fr/wiki/Développement-logiciel).
