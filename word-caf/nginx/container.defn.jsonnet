local applianceConf = import "CAF.conf.jsonnet";
local containerConf = import "container.conf.json";
local containerSecrets = import "nginx.secrets.jsonnet";
local traeficConf = import "traeficHost.conf.jsonet";

{
	"docker-compose.yml" : std.manifestYamlDoc({
		version: '3.4',

		services: {
			container: {
				container_name: containerConf.containerName,
				image: 'nginx',
				restart: 'always',
				networks: ['network'],
                                ports: [containerSecrets.httpPort + ':80', containerSecrets.httpsPort + ':443'],
				volumes: ['/opt/containers/data/wordpress1:/usr/share/nginx/html', './default.conf:/etc/nginx/conf.d/default.conf', './dhit.crt:/opt/dhit.crt', './dhit.key:/opt/dhit.key'],
                                labels: {
                                        'traefik.enable': 'true',
                                        'traefik.docker.network': applianceConf.defaultDockerNetworkName,
                                        'traefik.domain': traeficConf.qnocsServerHost,
                                        'traefik.backend': containerConf.containerName,
                                         'traefik.protocol': 'https',
                                        'traefik.port': '443',
                                        'traefik.frontend.entryPoints': 'https',
                                        'traefik.frontend.headers.SSLRedirect': 'true',
                                        'traefik.frontend.rule': 'Host: '+traeficConf.qnocsServerHost,
                                }

			},
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
