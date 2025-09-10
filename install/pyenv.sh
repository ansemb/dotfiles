#!/usr/bin/env bash

if [[ -z "${PYENV_ROOT+x}" ]]; then
  PYENV_ROOT="${HOME}/.pyenv"
fi
export PYENV_ROOT
export PATH="${PYENV_ROOT}/bin:${PATH}"


#########################################
# PYENV

install_pyenv() {
  if pyenv_exists; then
    echo "pyenv already exists. skipping installation..."
    return
  fi
  echo "pyenv not found."
  if [[ "${OS}" == "Linux" ]]; then
    echo "installing pyenv to: ${PYENV_ROOT}"
    git clone https://github.com/pyenv/pyenv.git "${PYENV_ROOT}"
    pushd "${PYENV_ROOT}" >/dev/null
    src/configure && make -C src
    popd >/dev/null
    eval "$(pyenv init -)"
  elif [[ "${OS}" == "Darwin" ]]; then
    if command -v brew >/dev/null 2>&1; then
      brew update
      brew install pyenv
    else
      echo "Homebrew not found; install it first to install pyenv on macOS." >&2
    fi
  fi
  echo
}

get_python_version() {
  local prompt="$1"
  local number
  read -r -p "${prompt}: " number
  if [[ "${number}" == "q" ]]; then
    py_version=-1
  elif [[ "${number}" == "s" ]]; then
    py_version=0
  elif [[ " ${PY_VERSIONS[*]} " == *" ${number} "* ]]; then
    py_version="${number}"
  else
    get_python_version 'Invalid number. Try again (s to skip/q to quit)'
  fi
}

user_prompt_require_pyenv_install_python() {
  if ! pyenv_exists; then
    echo "pyenv does not exist. exiting..."
    exit 1
  fi
  eval "$(pyenv init -)"
  if [[ "$(pyenv global)" != "system" ]]; then
    echo "python version found with pyenv. skipping python installation..."
    return
  fi
  local latest_py
  latest_py=$(pyenv install --list | perl -nle 'print if m{^\s*(\d|\.)+\s*$}' | tail -1 | xargs)
  echo
  echo "No python version is installed from pyenv. This is required."
  echo "Pyenv found latest python version: ${latest_py}"
  py_version="${latest_py}"
  local ans
  read -r -p "Install this python version? [Y/n] " ans || true
  echo
  if [[ ${ans:-Y} =~ ^[Nn]$ ]]; then
    mapfile -t PY_VERSIONS < <(pyenv install --list | perl -nle 'print if m{^\s*3\.(\d|\.)+\s*$}' | sed 's/^\s*//; s/\s*$//')
    echo 'Available python versions:'
    printf '%s\n' "${PY_VERSIONS[@]}"
    get_python_version 'Select version to install (q to quit/s to skip)'
  fi
  # handle quit before attempting install
  if [[ "${py_version}" == "-1" ]]; then
    echo
    echo "exiting..."
    exit 0
  fi
  # install only if a version was chosen (not skip)
  if [[ "${py_version}" != "0" ]]; then
    # ensure chosen value looks like a version string to avoid accidental install attempts
    if [[ "${py_version}" =~ ^[0-9]+(\.[0-9]+){1,2}$ ]]; then
      pyenv install "${py_version}" || true
      pyenv global "${py_version}" || true
    else
      echo "Invalid python version string '${py_version}', skipping install." >&2
    fi
  fi
  echo
}

  install_pyenv
  user_prompt_require_pyenv_install_python
