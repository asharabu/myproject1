local applianceConf = import "CAF.conf.jsonnet";
local containerConf = import "container.conf.json";
local containerSecrets = import "mysql.secrets.jsonnet";

{
	"docker-compose.yml" : std.manifestYamlDoc({
		version: '3.4',

		services: {
			container: {
				container_name: containerConf.containerName,
				image: 'mysql:5.7',
				restart: 'always',
				ports: [containerSecrets.databasePort + ':3306'],
				networks: ['network'],
				volumes: ['/opt/containers/data/word1-mysql:/var/lib/mysql'],
				environment: [
					'MYSQL_ROOT_HOST=%',  // allow root access from any host (TODO: make this secure later)
					'MYSQL_ROOT_PASSWORD=' + containerSecrets.rootPassword,
                                        'MYSQL_DATABASE=' + containerSecrets.wordpressdatabase,
                                        'MYSQL_USER=' + containerSecrets.wordpressusr,
                                        'MYSQL_PASSWORD=' + containerSecrets.mysqlusrpass
				]
			}
		},

		networks: {
			network: {
				external: {
					name: applianceConf.defaultDockerNetworkName
				},
			},
		},

		volumes: {
			storage: {
				name: containerConf.containerName
			},
		},
	}),

}
