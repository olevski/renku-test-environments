#!/usr/bin/env bash
set -euox pipefail

GATK_VERSION=4.6.2.0
PICARD_VERSION=3.4.0
PERSISTENT_DIR="${RENKU_MOUNT_DIR:-$HOME}"
GATK_INSTALL_DIR="${PERSISTENT_DIR}/gatk-${GATK_VERSION}"
PICARD_INSTALL_DIR="${PERSISTENT_DIR}/picard"

mkdir -p "$PICARD_INSTALL_DIR"
curl -fsSL -o /tmp/gatk.zip https://github.com/broadinstitute/gatk/releases/download/${GATK_VERSION}/gatk-${GATK_VERSION}.zip
unzip -q /tmp/gatk.zip -d "$PERSISTENT_DIR"
rm -f /tmp/gatk.zip
curl -fsSL -o "${PICARD_INSTALL_DIR}/picard.jar" https://github.com/broadinstitute/picard/releases/download/${PICARD_VERSION}/picard.jar
cat >"${PICARD_INSTALL_DIR}/picard" <<EOF
#!/usr/bin/env bash
exec java -jar ${PICARD_INSTALL_DIR}/picard.jar "\$@"
EOF
chmod +x "${PICARD_INSTALL_DIR}/picard"

echo >>~/.bashrc
printf 'export PATH="%s:%s:$PATH"' "${GATK_INSTALL_DIR}" "${PICARD_INSTALL_DIR}" >>~/.bashrc
echo >>~/.bashrc

export PIPX_HOME="${PERSISTENT_DIR}/pipx"
export PIPX_BIN_DIR="${PERSISTENT_DIR}/pipx_bin"
mkdir -p "$PIPX_HOME" "$PIPX_BIN_DIR"
printf 'export PATH="%s:$PATH"' "${PIPX_BIN_DIR}" >>~/.bashrc
echo >>~/.bashrc
printf 'export PIPX_HOME=%s' "$PIPX_HOME" >>~/.bashrc
echo >>~/.bashrc
printf 'PIPX_BIN_DIR=%s' "$PIPX_BIN_DIR" >>~/.bashrc
echo >>~/.bashrc
pipx install multiqc==1.33
