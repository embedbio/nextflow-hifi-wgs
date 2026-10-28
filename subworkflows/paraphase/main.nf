/*
========================================================================================
    MODULE IMPORT
========================================================================================
*/

include { paraphase } from '../../modules/paraphase/'


/*
========================================================================================
    SUBWORKFLOW: Paraphase segmental duplication genotyping
========================================================================================
*/

workflow PARAPHASE_GENOTYPING {

    take:
    aligned_bam_ch    // channel: tuple(sample_id, bam, bai)
    fasta             // path(fasta)
    fasta_idx         // path(fasta idx)

    main:

    paraphase(
        aligned_bam_ch,
        fasta,
        fasta_idx
    )

    emit:

    json    = paraphase.out.json     // tuple(sample_id, json)
    bam     = paraphase.out.bam      // tuple(sample_id, bam, bai)
    vcf_dir = paraphase.out.vcf_dir  // tuple(sample_id, vcf_dir)
}
