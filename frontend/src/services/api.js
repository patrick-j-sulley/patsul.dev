const API_BASE = import.meta.env.PUBLIC_API_URL || 'http://127.0.0.1:8000/api';
  
  // Project API calls
  export async function fetchProjects() {
    return request('/projects/');
  }
  
  export async function fetchProject(id) {
    return request(`/projects/${id}/`);
  }

