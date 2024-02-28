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

        ////dx: ���� ��ġ���� x������ 1��ŭ ���� ���ؼ� ������ �̵��� �Ÿ�
        //float dx = Vector3.Dot(transform.right, worldDeltaPosition);
        ////dy: ���� ��ġ���� z������ 1��ŭ �� ���� ���ؼ� ������ �̵��� �Ÿ�.
        //float dy = Vector3.Dot(transform.forward, worldDeltaPosition);

        ////dx, dy��ŭ ���� ���ؼ��� �̵� ����(����� �Ÿ��� ����)
        //Vector2 deltaPosition = new Vector2(dx, dy);

        //// Low-pass filter the deltaMove
        //float smooth = Mathf.Min(1, Time.deltaTime / 0.1f);
        //// filter�� ��ģ ���� ���翡�� �̵� ���͸�ŭ ���� ��
        //smoothDeltaPos = Vector2.Lerp(smoothDeltaPos, deltaPosition, smooth);

        ////�����Ӱ� �̵���
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
