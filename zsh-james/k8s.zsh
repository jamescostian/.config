if hash kubectl 2> /dev/null; then
	source <(kubectl completion zsh)
	alias k="kubectl"
	complete -F __start_kubectl k
fi

alias mk="minikube"

function kpods {
	kubectl get pods -o custom-columns=:metadata.name --no-headers -l "app=$1"
}
function kdbg {
	echo "Be sure to first run this and allow port forwarding and use --inspect:"
	echo "   kubectl edit deployment $1"
	echo "Example of what you'd add to the YAML:"
	echo "        ports:"
	echo "        - containerPort: 1234"
	echo "          name: http"
	echo "          protocol: TCP"
	echo "        - containerPort: 9229"
	echo "          name: debug"
	echo "          protocol: TCP"
	echo "        command:"
	echo "          - sh"
	echo "          - '-c'"
	echo "          - 'node --inspect ./app.js'"
	echo "That all goes inside spec.template.metadata.spec.containers"
	echo "Note that there will already be a ports defined in there, and maybe even a command!"
	echo "Also note that 'node --inspect ./app.js' may not be right for every app."
	echo "Check the Dockerfile and package.json scripts to see what all you may need to run."
	echo "You'll also need to wait for your new pods to be running and to replace the old ones."
	echo "For that, run:"
	echo "  watch -n 0.5 kubectl get pods -l app=$1"
	echo
	read -k "?Hit enter when you've done all the above"
	echo "Open Chrome and go to chrome://inspect"
	LOCAL_PORT=9232;
	CONCURRENTLY_ARGS="-k"
	for POD_NAME in $(kpods "$1"); do
			CONCURRENTLY_ARGS="$CONCURRENTLY_ARGS\n'kubectl port-forward $POD_NAME $LOCAL_PORT:9229'"
			let LOCAL_PORT+=1
	done
	echo $CONCURRENTLY_ARGS | xargs npx concurrently
}
