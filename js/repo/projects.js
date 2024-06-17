export async function index() {
    const response = await fetch('/api/projects')
    return await response.json()
}

export async function show(key) {
    const response = await fetch(`/api/projects/${key}`)
    return response.json()
}
