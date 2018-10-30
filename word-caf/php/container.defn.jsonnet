local applianceConf = import "CAF.conf.jsonnet";
local containerConf = import "container.conf.json";
local containerSecrets = import "php.secrets.jsonnet";

{
	"docker-compose.yml" : std.manifestYamlDoc({
		version: '3.4',

		services: {
			container: {
				container_name: containerConf.containerName,
				image: 'bitnami/php-fpm:7.2',
				restart: 'always',
				ports: [containerSecrets.phpPort + ':9000'],
                                networks: ['network'],
				volumes: ['/opt/containers/data/wordpress1:/usr/share/nginx/html']
                             }
                },

		networks: {
			network: {
				external: {
					name: applianceConf.defaultDockerNetworkName
				},
			},
		},

	}),

}
