export async function index() {
    const response = await fetch('/api/projects')
    return await response.json()
}
