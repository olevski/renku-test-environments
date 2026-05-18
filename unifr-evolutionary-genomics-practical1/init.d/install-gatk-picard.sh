#!/usr/bin/env bash
set -euo pipefail

GATK_VERSION=4.6.2.0
PICARD_VERSION=3.4.0
PERSISTENT_DIR="${RENKU_MOUNT_DIR:-~}"
GATK_INSTALL_DIR="${PERSISTENT_DIR}/gatk"
PICARD_INSTALL_DIR="${PERSISTENT_DIR}/picard"

mkdir -p "$PICARD_INSTALL_DIR"
mkdir -p "$GATK_INSTALL_DIR"
curl -fsSL -o /tmp/gatk.zip https://github.com/broadinstitute/gatk/releases/download/${GATK_VERSION}/gatk-${GATK_VERSION}.zip
unzip -q /tmp/gatk.zip -d "$GATK_INSTALL_DIR"
rm -f /tmp/gatk.zip
curl -fsSL -o "${PICARD_INSTALL_DIR}/picard.jar" https://github.com/broadinstitute/picard/releases/download/${PICARD_VERSION}/picard.jar
printf '%s\n' '#!/usr/bin/env bash' 'exec java -jar /opt/picard/picard.jar "$@"' > "${PICARD_INSTALL_DIR}/picard"
chmod +x "${PICARD_INSTALL_DIR}/picard"

echo "\n" > ~/.bashrc
printf 'export PATH="%s:%s:$PATH"\n' "${GATK_INSTALL_DIR}" "${PICARD_INSTALL_DIR}" >> ~/.bashrc

# pipx install multiqc==1.33