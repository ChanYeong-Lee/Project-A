using System.Collections;
using System.Collections.Generic;
using Unity.VisualScripting;
using UnityEngine;
using UnityEngine.AI;

public class MerchantMove : MonoBehaviour
{
    public NavMeshAgent agent;
    public Animator anim;

    public NavMeshTriangulation triangulation;

    public Vector3 nexPos;
    public Vector2 vel;
    public Vector2 smoothDeltaPos;

    private void Start()
    {
        Init();
    }
    public void Init()
    {
      
        agent = GetComponent<NavMeshAgent>();   
        anim = GetComponent<Animator>();
        triangulation = NavMesh.CalculateTriangulation();



    }
    //private void FixedUpdate()
    //{
    //    SynchronizeanimAndagent();
    //}
    //public void SynchronizeanimAndagent()
    //{
      
    //}

    void Update()
    {
        if (agent.hasPath)
        {
            Vector3 dir = (agent.steeringTarget - transform.position).normalized;
            Vector3 animDir = transform.InverseTransformDirection(dir);
            bool isFacingMoveDirection = Vector3.Dot(dir, transform.forward) > 0.5f;



            anim.SetFloat("Horizontal", isFacingMoveDirection ? animDir.x : 0, 0.5f, Time.deltaTime);
            anim.SetFloat("Vertical", isFacingMoveDirection ? animDir.y : 0, 0.5f, Time.deltaTime);

            transform.rotation = Quaternion.RotateTowards(transform.rotation, Quaternion.LookRotation(dir), 180 * Time.deltaTime);

            if (Vector3.Distance(transform.position, agent.destination) < agent.radius)
            {
                SetRandomPos();
            }

        }

        //Vector3 worldDeltaPosition = agent.nextPosition - transform.position;
        //worldDeltaPosition.y = 0;

        ////Map worldDeltaPos to local space

        ////dx: 현재 위치에서 x축으로 1만큼 가기 위해서 실제로 이동할 거리
        //float dx = Vector3.Dot(transform.right, worldDeltaPosition);
        ////dy: 현재 위치에서 z축으로 1만큼 더 가기 위해서 실제로 이동할 거리.
        //float dy = Vector3.Dot(transform.forward, worldDeltaPosition);

        ////dx, dy만큼 가기 위해서의 이동 백터(방향과 거리를 포함)
        //Vector2 deltaPosition = new Vector2(dx, dy);

        //// Low-pass filter the deltaMove
        //float smooth = Mathf.Min(1, Time.deltaTime / 0.1f);
        //// filter를 거친 현재 현재에서 이동 백터만큼 보간 값
        //smoothDeltaPos = Vector2.Lerp(smoothDeltaPos, deltaPosition, smooth);

        ////프레임간 이동량
        //vel = smoothDeltaPos / Time.deltaTime;

        //if (agent.remainingDistance <= agent.stoppingDistance)
        //{
        //    vel = Vector2.Lerp(Vector2.zero, vel, agent.remainingDistance / agent.stoppingDistance);
        //}

        //bool shouldMove = vel.magnitude > 0.5f && agent.remainingDistance > agent.stoppingDistance;
        //print($"vel.magnitude: {vel.magnitude}");
        //anim.SetBool("move", shouldMove);
        //anim.SetFloat("Horizontal", vel.x);
        //anim.SetFloat("Vertical", vel.y);

        else
        {
            anim.SetFloat("Horizontal", 0, 0.25f, Time.deltaTime);
            anim.SetFloat("Vertical", 0, 0.25f, Time.deltaTime);
        }
    }

    public void SetRandomPos()
    {
        int index = UnityEngine.Random.Range(1, triangulation.vertices.Length - 1);
        agent.SetDestination(Vector3.Lerp(triangulation.vertices[index],
                            triangulation.vertices[index + (UnityEngine.Random.value > 0.5f ? -1 : 1)], UnityEngine.Random.value));
    }

}
