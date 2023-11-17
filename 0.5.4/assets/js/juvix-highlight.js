document$.subscribe(() => {
  hljs.registerLanguage("juvix", hljsDefineJuvix);
  hljs.registerLanguage("jrepl", hljsDefineJuvixRepl);
  hljs.highlightAll();
});
