using System.Collections;
using System.Collections.Generic;
using Unity.AI.Navigation;
using UnityEngine;

public class TestNavMeshBuilder : MonoBehaviour
{
    [SerializeField] private Transform target;

    private NavMeshSurface surface;
    private void Awake()
    {
        surface = GetComponent<NavMeshSurface>();
    }

    private void Start()
    {
        surface.BuildNavMesh();
    }

    private void Update()
    {
        if (100.0f < Vector3.Distance(transform.position, target.position))
        {
            transform.position = target.position;
            surface.BuildNavMesh();
        }
    }
}
