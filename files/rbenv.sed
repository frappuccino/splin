1i\export RBENV_ROOT="${HOME}\/.rbenv"\nif [ -d "${RBENV_ROOT}" ]; then\n  export PATH="${RBENV_ROOT}\/bin:${PATH}"\n  eval "$(rbenv init -)"\nfi
