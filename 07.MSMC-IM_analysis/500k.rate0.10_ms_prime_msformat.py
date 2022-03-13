import msprime
import sys

Ne = 1e4
length = 3e7
mutation_rate = 1e-8
recombination_rate = 8e-9

## change here
num_replicates = 30

N0 = Ne



population_configurations = [
    msprime.PopulationConfiguration(initial_size = N0),
    msprime.PopulationConfiguration(initial_size = N0)
]

## change here
T0 = 0
#T0 = int(4 * Ne * 0.25) #100kya
#T0 = int(4 * Ne * 0.125) #50kya
#T0 = int(4 * Ne * 0.3)

samples = [msprime.Sample(population = 0, time = T0)] * 4 + [msprime.Sample(population = 1, time = 0)] * 4

## migration time for 10% migration
Tm1 = int(4 * Ne * 0.25)

## change here
T1 = int(4 * Ne * 1.25)
N1 = 4 * Ne

T2 = int(4 * Ne * 3)

demographic_events = [
    msprime.MassMigration(time = Tm1, source = 1, destination = 0, proportion = 0.10),
    msprime.PopulationParametersChange(time = Tm1, initial_size = N0, population_id = 0),
    msprime.MassMigration(time = Tm1, source = 0, destination = 1, proportion = 0.04),
    msprime.PopulationParametersChange(time = Tm1, initial_size = N0, population_id = 1),
    msprime.MassMigration(time = T1, source = 0, destination = 1, proportion = 1.0),
    msprime.PopulationParametersChange(time = T1, initial_size = N1, population_id = 1),
    msprime.PopulationParametersChange(time = T2, initial_size = N1, population_id = 1),
]

################
fossil_model = msprime.simulate(
    Ne = Ne,
    length = length,
    mutation_rate = mutation_rate,
    recombination_rate = recombination_rate,
    num_replicates = num_replicates,
    population_configurations = population_configurations,
    samples = samples,
    demographic_events = demographic_events
    )

#for index,sequence in enumerate(fossil_model):
#    out_vcf = open("120kya.fossil_repeat_{}_20200408.vcf".format(1 + index), "w")
#    sequence.write_vcf(out_vcf, 2)
#    out_vcf.close()

def write_ms(ts, f, length):
    print("ms 8 30 -t ", file = f)
    print("12345 12354 12435", file = f)
    print("", file = f)
    print("", file = f)
    print("//", file = f)
    print("segsites: {}".format(ts.get_num_mutations()), file = f)
    print("positions:", file = f, end = "")
    for mut in ts.mutations():
        print(" {:.7f}".format(mut.position / length), file = f, end = "")
    print("", file = f)
    ts_geno = ts.genotype_matrix()
    for geno in zip(*ts_geno):
        print("{}".format("".join(map(str, geno))), file = f)


for index,sequence in enumerate(fossil_model):
#    out_ms = open("argv[0]_500kya.rate0.1.P2_Ne_repeat_{}_20210205.ms".format(1 + index), "w")
    out_ms = open("{}_500kya.sigle.rate10_04.P2_Ne_repeat_{}.ms".format(sys.argv[1],1 + index), "w")
    write_ms(sequence, out_ms, length)
    out_ms.close()
