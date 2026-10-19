# Benchmark Baselines

The **Refresh benchmark baselines** GitHub Actions workflow generates `startup.json`
and `rendering.json` on `ubuntu-26.04` and opens a pull request to commit them under
`ubuntu-26.04/`. Review and merge that pull request to establish or update the CI
regression baseline.

CI compares results with the committed baselines for the same runner image and
rejects median timing increases above 20%. Missing baselines are reported in the
summary and their comparisons are skipped until the generated files are merged.
Ordinary CI runs leave the baselines unchanged.
