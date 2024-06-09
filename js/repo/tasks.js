export async function index(project) {
    const url = new URL('/api/tasks', window.location)
    url.searchParams.append('project', project)

    const response = await fetch(url)
    return await response.json()
}
