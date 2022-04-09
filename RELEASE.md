# What to do for a release?

```
perl Makefile.PL
make check
make test
```

Update `Changes` with user-visible changes.

Check the copyright year in the `LICENSE`.

Double check the `MANIFEST`. Did we add new files that should be in
here?

```
perl Makefile.PL
make manifest
```

Increase the version in `lib/Game/TextMapper.pm`.

Commit any changes and tag the release.

Prepare an upload by using n.nn_nn for a developer release:

```
perl Makefile.PL
make distdir
mv Game-CharacterSheetGenerator-1.00 Game-CharacterSheetGenerator-1.00_00
tar czf Game-CharacterSheetGenerator-1.00_00.tar.gz Game-CharacterSheetGenerator-1.00_00
trash Game-CharacterSheetGenerator-1.00_00
cpan-upload -u SCHROEDER Game-CharacterSheetGenerator-1.00_00.tar.gz
```

If you’re happy with the results:

```
perl Makefile.PL && make && make dist
cpan-upload -u SCHROEDER Game-CharacterSheetGenerator-1.tar.gz
```
