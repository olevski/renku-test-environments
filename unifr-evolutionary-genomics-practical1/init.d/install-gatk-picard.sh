#!/usr/bin/env bash
set -euox pipefail

GATK_VERSION=4.6.2.0
PICARD_VERSION=3.4.0
PERSISTENT_DIR="${RENKU_MOUNT_DIR:-$HOME}/tools"
GATK_INSTALL_DIR="${PERSISTENT_DIR}/gatk-${GATK_VERSION}"
PICARD_INSTALL_DIR="${PERSISTENT_DIR}/picard"
mkdir -p "$PERSISTENT_DIR"

if [ ! -d "$PICARD_INSTALL_DIR" ]; then
  mkdir -p "$PICARD_INSTALL_DIR"
  curl -fsSL -o "${PICARD_INSTALL_DIR}/picard.jar" https://github.com/broadinstitute/picard/releases/download/${PICARD_VERSION}/picard.jar
  cat >"${PICARD_INSTALL_DIR}/picard" <<EOF
#!/usr/bin/env bash
exec java -jar ${PICARD_INSTALL_DIR}/picard.jar "\$@"
EOF
  chmod +x "${PICARD_INSTALL_DIR}/picard"
  printf 'export PATH="%s:$PATH"' "${PICARD_INSTALL_DIR}" >>~/.bashrc
fi

if [ ! -d "$GATK_INSTALL_DIR" ]; then
  curl -fsSL -o /tmp/gatk.zip https://github.com/broadinstitute/gatk/releases/download/${GATK_VERSION}/gatk-${GATK_VERSION}.zip
  unzip -q /tmp/gatk.zip -d "$PERSISTENT_DIR"
  rm -f /tmp/gatk.zip
  echo >>~/.bashrc
  printf 'export PATH="%s:$PATH"' "${GATK_INSTALL_DIR}" >>~/.bashrc
  echo >>~/.bashrc
fi

export PIPX_HOME="${PERSISTENT_DIR}/pipx"
export PIPX_BIN_DIR="${PERSISTENT_DIR}/pipx_bin"
if [ ! -d "$PIPX_HOME" ]; then
  mkdir -p "$PIPX_HOME" "$PIPX_BIN_DIR"
  printf 'export PATH="%s:$PATH"' "${PIPX_BIN_DIR}" >>~/.bashrc
  echo >>~/.bashrc
  printf 'export PIPX_HOME=%s' "$PIPX_HOME" >>~/.bashrc
  echo >>~/.bashrc
  printf 'PIPX_BIN_DIR=%s' "$PIPX_BIN_DIR" >>~/.bashrc
  echo >>~/.bashrc
  pipx install multiqc==1.33
fi

QUARTO_VERSION="1.9.37"
QUARTO_INSTALL_DIR="${PERSISTENT_DIR}/quarto-${QUARTO_VERSION}"
if [ ! -d "$QUARTO_INSTALL_DIR" ]; then
  curl -fsSL "https://github.com/quarto-dev/quarto-cli/releases/download/v${QUARTO_VERSION}/quarto-${QUARTO_VERSION}-linux-amd64.tar.gz" | tar -xz -C "$PERSISTENT_DIR"
  printf 'export PATH="%s:$PATH"' "${QUARTO_INSTALL_DIR}/bin" >>~/.bashrc
  echo >>~/.bashrc
fi
