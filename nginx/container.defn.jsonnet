local applianceConf = import "CAF.conf.jsonnet";
local containerConf = import "container.conf.json";
local containerSecrets = import "nginx.secrets.jsonnet";

{
	"docker-compose.yml" : std.manifestYamlDoc({
		version: '3.4',

		services: {
			container: {
				container_name: containerConf.containerName,
				image: 'nginx',
				restart: 'always',
				ports: [containerSecrets.httpPort + ':80', containerSecrets.httpsPort + ':443'],
				networks: ['network'],
				volumes: ['/opt/containers/data/wordpress1:/usr/share/nginx/html', './default.conf:/etc/nginx/conf.d/default.conf'],
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
