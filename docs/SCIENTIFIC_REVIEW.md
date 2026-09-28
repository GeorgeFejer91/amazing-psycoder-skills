# Scientific review of the English fork

Review date: 2026-09-28. This is a targeted scientific and translation review of the seven `SKILL.md` entry points, their routing guidance, and selected high-impact method and paradigm cards. All Markdown under `amazing-psycoder/` was translated into English, including code comments and example participant instructions. Runtime aliases that encode multilingual input are unchanged. Translation and review do not certify every one of the 60 analysis method cards, 38 paradigm cards, 48 plot cards, or executable example as scientifically valid for a new study.

## Corrections made

- **Mixed models:** Removed the claim that trial-level analysis has power proportional to subjects × trials or that mixed models automatically fix missing data. Power depends on the design, subject/item counts, variance structure, and estimand. More trials can improve precision without creating independent participants [1].
- **Power:** Removed observed post-hoc power as a retrospective quality check. It is a function of the observed test result and adds no useful information; report an effect estimate and uncertainty interval instead [2].
- **Signal detection:** Recomputed the illustrative hit/false-alarm example using equally frequent signal and noise trials. Removed group test statistics and confidence intervals that were inconsistent with the stated sample sizes and summary statistics. The example now requires the user to insert actual computed results.
- **Diffusion model:** Removed a universal trial-count cutoff and a code/report mismatch: the old example claimed condition effects on boundary and non-decision parameters that its formula did not fit. The revised `brms` example uses `dec(choice)` with explicit lower/upper response coding, as required by the official `brms` documentation [3].
- **Equivalence testing:** Replaced a contradictory example that reported a 90% CI wholly inside the stated equivalence bounds yet concluded non-equivalence. The report now requires the computed 90% CI and prespecified bounds to agree.
- **Reliability:** Removed universal qualitative labels based on α and a logically invalid item-deletion interpretation. Reliability depends on the score use, population, item structure, and measurement model [4].
- **Other method cards:** Corrected a pseudo-*R*² interpretation as literal variance explained, an absence-of-proportional-bias claim based solely on a nonsignificant test, and the rule that Dunnett/Games-Howell comparisons require a significant omnibus ANOVA.
- **Experiment examples:** Translated participant-facing English examples and replaced a mixed-language IAT item set. Any translated stimuli must be reviewed against the intended construct before actual data collection.

## Use conditions

The method cards are candidate reminders under `psy-ana-designer/methods/USAGE.md`. Confirm the estimand, task design, scoring rules, exclusions, and model assumptions against the actual protocol. Verify current software syntax and calculate every reported number from the study data. For Study 5, the project's cleared publication pool and preregistration take precedence over generic examples.

## References

1. M. Brysbaert and M. A. Stevens (2018), *Journal of Cognition*, [Power Analysis and Effect Size in Mixed Effects Models: A Tutorial](https://consensus.app/papers/power-analysis-and-effect-size-in-mixed-effects-models-a-brysbaert-stevens/e081e2fc403250519ef1492a505bb9c6/?utm_source=chatgpt). DOI: 10.5334/joc.10. Consensus citation count at review: 1,176.
2. J. J. Dziak, L. Dierker, and B. Abar (2018), *Current Psychology*, [The Interpretation of Statistical Power after the Data have been Gathered](https://consensus.app/papers/the-interpretation-of-statistical-power-after-the-data-dziak-dierker/184eca0df21b574d9b4e6fdd84093f44/?utm_source=chatgpt). DOI: 10.1007/s12144-018-0018-1. Consensus citation count at review: 175.
3. `brms`, [model-formula documentation](https://paulbuerkner.com/brms/reference/brmsformula.html) and [family documentation](https://paulbuerkner.com/brms/reference/brmsfamily.html), accessed 2026-09-28.
4. A. F. Hayes and J. J. Coutts (2020), *Communication Methods and Measures*, [Use Omega Rather than Cronbach’s Alpha for Estimating Reliability. But…](https://consensus.app/papers/use-omega-rather-than-cronbach’s-alpha-for-estimating-hayes-coutts/c84028d9239b5f4fb16917ae243360d5/?utm_source=chatgpt). DOI: 10.1080/19312458.2020.1718629. Consensus citation count at review: 2,451.
