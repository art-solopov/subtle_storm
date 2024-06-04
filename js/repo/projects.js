export async function index() {
    const response = await fetch('http://localhost:8000/api/projects')
    return await response.json()
}
