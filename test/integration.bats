PATH="$PWD/src:$PWD/bin:$PATH"

setup () {
  if ! [[ -e test/mock/repository ]]; then
    mock-repository test/mock/repository test/mock/commits
  fi

  cd test/mock/repository || true

  git checkout main 2> /dev/null
  git branch -D release/mock-test 2> /dev/null || true
  git checkout HEAD~100 2> /dev/null
  git checkout -b release/mock-test 2> /dev/null
}

@test "--dry-run --new" {
  run git-draft main PRD-26822 PRD-3893 --dry-run --new
  [[ "$status" -eq 0 ]]
  [[ "$output" = *"PRD-26822"* ]]
  [[ "$output" = *"PRD-3893"* ]]
  [[ "$output" != *"FX-1815"* ]]
}

@test "--dry-run --all" {
  run git-draft main PRD-3893 --dry-run --all --color
  [[ "$status" -eq 0 ]]
}

@test "--dry-run --revert" {
  git checkout main
  run git-draft PRD-3893 --dry-run --revert --all
  [[ "$status" -eq 0 ]]
  [[ "$output" = *"PRD-3893"* ]]
}

@test "different word delimiter before and after" {
  run git-draft main FX-1816 --new
  [[ "$status" -eq 0 ]]
}

teardown() {
  git checkout main 2> /dev/null
  git branch -D release/mock-test > /dev/null
  cd ../../../
}
