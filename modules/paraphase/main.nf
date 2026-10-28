process paraphase {
    /*
     * Paraphase: haplotype-resolved copy number and variant calling for genes in
     * segmental duplications (SMN1/SMN2, CYP2D6, GBA, PMS2, ...) from a HiFi WGS BAM.
     * The input BAM must be aligned to the whole reference (no ALT contigs).
     */
    tag "$sample_id"
    publishDir { "${params.paraphase_output_dir}/${sample_id}" }, mode: 'copy'

    container "quay.io/pacbio/paraphase:4.1.0_build1"

    input:
    tuple val(sample_id), path(bam), path(bam_index)
    path reference
    path reference_index

    output:
    tuple val(sample_id), path("${sample_id}.paraphase.json"), emit: json
    tuple val(sample_id), path("${sample_id}.paraphase.bam"), path("${sample_id}.paraphase.bam.bai"), emit: bam
    tuple val(sample_id), path("${sample_id}_paraphase_vcfs"), emit: vcf_dir, optional: true

    script:
    """
    set -euo pipefail

    paraphase \\
        -b ${bam} \\
        -r ${reference} \\
        -o . \\
        -p ${sample_id} \\
        -t ${task.cpus} \\
        --genome ${params.paraphase_genome}
    """

    stub:
    """
    touch ${sample_id}.paraphase.json
    touch ${sample_id}.paraphase.bam
    touch ${sample_id}.paraphase.bam.bai
    mkdir -p ${sample_id}_paraphase_vcfs
    """
}
