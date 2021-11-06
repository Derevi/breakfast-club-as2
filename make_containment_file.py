subsystems = ['bootstrap', 'main', 'postmaster', 'interfaces', 'libpq', 'tcop', 'parser', 'rewrite', 'optimizer'
              , 'executor', 'jit', 'storage', 'contrib', 'support', 'auxiliary']
# optimizer_subsystems = ['optimizer_path']
containment = []
src_path = '$INSTANCE postgresql-13.4/src/'
backend_path = src_path + 'backend/'
include_path = src_path + 'include/'

for s in subsystems:
    containment.append('contain postgresql-13.4 ' + s + '.ss\n')

# for s in optimizer_subsystems:
#    print(s)
#    containment.append('contain optimizer ' + s + '.ss\n')

with open ('Postgres_UnderstandFileDependency.raw.ta', 'rt') as postgres:
    for file in postgres:
        if file.find('$INSTANCE postgresql-13.4/contrib') != -1:
            containment.append("contain contrib.ss " + file.replace('$INSTANCE ', '').replace(' cFile', '')
                         .replace(' hFile', ''))
        elif file.find(src_path) != -1:
            if file.find(backend_path) != -1:
                if file.find(backend_path + 'access') != -1 or file.find(backend_path + 'catalog') != -1\
                    or file.find(backend_path + 'commands') != -1 or file.find(backend_path + 'nodes') != -1\
                    or file.find(backend_path + 'statistics') != -1\
                    or file.find(backend_path + 'utils') != -1:
                    containment.append("contain auxiliary.ss " + file.replace('$INSTANCE ', '').replace(' cFile', '')
                                       .replace(' hFile', ''))
                elif file.find(backend_path + 'bootstrap') != -1:
                    containment.append("contain bootstrap.ss " + file.replace('$INSTANCE ', '').replace(' cFile', '')
                                       .replace(' hFile', ''))
                elif file.find(backend_path + 'main') != -1:
                    containment.append("contain main.ss " + file.replace('$INSTANCE ', '').replace(' cFile', '')
                                       .replace(' hFile', ''))
                elif file.find(backend_path + 'postmaster') != -1:
                    containment.append("contain postmaster.ss " + file.replace('$INSTANCE ', '').replace(' cFile', '')
                                       .replace(' hFile', ''))
                elif file.find(backend_path + 'libpq') != -1:
                    containment.append("contain libpq.ss " + file.replace('$INSTANCE ', '').replace(' cFile', '')
                                       .replace(' hFile', ''))
                elif file.find(backend_path + 'tcop') != -1:
                    containment.append("contain tcop.ss " + file.replace('$INSTANCE ', '').replace(' cFile', '')
                                       .replace(' hFile', ''))
                elif file.find(backend_path + 'parser') != -1:
                    containment.append("contain parser.ss " + file.replace('$INSTANCE ', '').replace(' cFile', '')
                                       .replace(' hFile', ''))
                elif file.find(backend_path + 'rewrite') != -1:
                    containment.append("contain rewrite.ss " + file.replace('$INSTANCE ', '').replace(' cFile', '')
                                       .replace(' hFile', ''))
                elif file.find(backend_path + 'optimizer') != -1:
                    containment.append(
                            "contain optimizer.ss " + file.replace('$INSTANCE ', '').replace(' cFile', '')
                            .replace(' hFile', ''))
                    # if file.find(backend_path + 'optimizer/path'):
                    #    containment.append(
                    #        "contain optimizer_path.ss " + file.replace('$INSTANCE ', '').replace(' cFile', '')
                    #        .replace(' hFile', ''))
                    #else:
                    #    containment.append(
                    #        "contain optimizer.ss " + file.replace('$INSTANCE ', '').replace(' cFile', '')
                    #        .replace(' hFile', ''))

                elif file.find(backend_path + 'executor') != -1 or file.find(backend_path + 'partitioning') != -1:
                    containment.append("contain executor.ss " + file.replace('$INSTANCE ', '').replace(' cFile', '')
                                       .replace(' hFile', ''))
                elif file.find(backend_path + 'jit') != -1:
                    containment.append("contain jit.ss " + file.replace('$INSTANCE ', '').replace(' cFile', '')
                                       .replace(' hFile', ''))
                elif file.find(backend_path + 'storage') != -1:
                    containment.append("contain storage.ss " + file.replace('$INSTANCE ', '').replace(' cFile', '')
                                       .replace(' hFile', ''))
                elif file.find(backend_path + 'snowball') != -1 or file.find(backend_path + 'regex') != -1\
                    or file.find(backend_path + 'lib') != -1 or file.find(backend_path + 'replication') != -1\
                    or file.find(backend_path + 'tsearch') != -1 or file.find(backend_path + 'foreign') != -1\
                    or file.find(backend_path + 'pl') != -1 or file.find(backend_path + 'port') != -1:
                    containment.append("contain support.ss " + file.replace('$INSTANCE ', '').replace(' cFile', '')
                                       .replace(' hFile', ''))
            elif file.find(src_path + 'bin') != -1 or file.find(src_path + 'common') != -1\
                or file.find(src_path + 'fe_utils') != -1 or file.find(src_path + 'port') != -1\
                or file.find(src_path + 'test') != -1 or file.find(src_path + 'timezone') != -1\
                or file.find(src_path + 'tools') != -1 or file.find(src_path + 'tutorial') != -1\
                or file.find(src_path + 'pl') != -1:
                containment.append("contain auxiliary.ss " + file.replace('$INSTANCE ', '').replace(' cFile', '')
                                   .replace(' hFile', ''))
            elif file.find('$INSTANCE postgresql-13.4/src/interfaces') != -1:
                containment.append("contain interfaces.ss " + file.replace('$INSTANCE ', '').replace(' cFile', '')
                                   .replace(' hFile', ''))
            elif file.find(include_path) != -1:
                if file.find(include_path + 'access') != -1 or file.find(include_path + 'catalog') != -1\
                    or file.find(include_path + 'commands') != -1 or file.find(include_path + 'nodes') != -1\
                    or file.find(include_path + 'statistics') != -1\
                    or file.find(include_path + 'utils') != -1 or file.find(include_path + 'common') != -1\
                    or file.find(include_path + 'datatype') != -1 or file.find(include_path + 'mb') != -1\
                    or file.find(include_path + 'portability') != -1:
                    containment.append("contain auxiliary.ss " + file.replace('$INSTANCE ', '').replace(' cFile', '')
                                       .replace(' hFile', ''))
                elif file.find(include_path + 'bootstrap') != -1:
                    containment.append("contain bootstrap.ss " + file.replace('$INSTANCE ', '').replace(' cFile', '')
                                       .replace(' hFile', ''))
                elif file.find(include_path + 'main') != -1:
                    containment.append("contain main.ss " + file.replace('$INSTANCE ', '').replace(' cFile', '')
                                       .replace(' hFile', ''))
                elif file.find(include_path + 'postmaster') != -1:
                    containment.append("contain postmaster.ss " + file.replace('$INSTANCE ', '').replace(' cFile', '')
                                       .replace(' hFile', ''))
                elif file.find(include_path + 'libpq') != -1:
                    containment.append("contain libpq.ss " + file.replace('$INSTANCE ', '').replace(' cFile', '')
                                       .replace(' hFile', ''))
                elif file.find(include_path + 'tcop') != -1:
                    containment.append("contain tcop.ss " + file.replace('$INSTANCE ', '').replace(' cFile', '')
                                       .replace(' hFile', ''))
                elif file.find(include_path + 'parser') != -1:
                    containment.append("contain parser.ss " + file.replace('$INSTANCE ', '').replace(' cFile', '')
                                       .replace(' hFile', ''))
                elif file.find(include_path + 'rewrite') != -1:
                    containment.append("contain rewrite.ss " + file.replace('$INSTANCE ', '').replace(' cFile', '')
                                       .replace(' hFile', ''))
                elif file.find(include_path + 'optimizer') != -1:
                    containment.append("contain optimizer.ss " + file.replace('$INSTANCE ', '').replace(' cFile', '')
                                       .replace(' hFile', ''))
                elif file.find(include_path + 'executor') != -1:
                    containment.append("contain executor.ss " + file.replace('$INSTANCE ', '').replace(' cFile', '')
                                       .replace(' hFile', ''))
                elif file.find(include_path + 'jit') != -1:
                    containment.append("contain jit.ss " + file.replace('$INSTANCE ', '').replace(' cFile', '')
                                       .replace(' hFile', ''))
                elif file.find(include_path + 'storage') != -1:
                    containment.append("contain storage.ss " + file.replace('$INSTANCE ', '').replace(' cFile', '')
                                       .replace(' hFile', ''))
                elif file.find(include_path + 'snowball') != -1 or file.find(include_path + 'regex') != -1\
                    or file.find(include_path + 'lib') != -1 or file.find(include_path + 'replication') != -1\
                    or file.find(include_path + 'tsearch') != -1 or file.find(include_path + 'foreign') != -1\
                    or file.find(include_path + 'pl') != -1 or file.find(include_path + 'port') != -1:
                    containment.append("contain support.ss " + file.replace('$INSTANCE ', '').replace(' cFile', '')
                                       .replace(' hFile', ''))
                else:
                    containment.append("contain auxiliary.ss " + file.replace('$INSTANCE ', '').replace(' cFile', '')
                                       .replace(' hFile', ''))
        elif file.find('$INSTANCE postgresql-13.4/') != -1:
            containment.append("contain auxiliary.ss " + file.replace('$INSTANCE ', '').replace(' cFile', '')
                               .replace(' hFile', ''))

with open('file.txt', 'w') as f:
    f.writelines(containment)
