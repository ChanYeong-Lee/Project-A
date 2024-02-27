using System.Collections;
using System.Collections.Generic;
using Unity.VisualScripting;
using UnityEngine;
using UnityEngine.AI;

public class MerchantMove : MonoBehaviour
{
    public NavMeshAgent agent;
    public Animator anim;

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

        anim.applyRootMotion = true;
        agent.updatePosition = false;
        agent.updateRotation = true;

    }
    private void FixedUpdate()
    {
        SynchronizeanimAndagent();
    }
    public void SynchronizeanimAndagent()
    {
        Vector3 worldDeltaPosition = agent.nextPosition - transform.position;
        worldDeltaPosition.y = 0;

        // 이동하는 방향으로 회전하고, 그 전까지는 anglur만 돌리는 로직
        float dx = Vector3.Dot(transform.right, worldDeltaPosition);
        float dy = Vector3.Dot(transform.forward, worldDeltaPosition);
        Vector2 deltaPosition = new Vector2(dx, dy);

        float smooth = Mathf.Min(1, Time.deltaTime / 0.1f);
        smoothDeltaPos = Vector2.Lerp(smoothDeltaPos, deltaPosition, smooth);

        vel = smoothDeltaPos / Time.deltaTime;
        if (agent.remainingDistance <= agent.stoppingDistance)
        {
            vel = Vector2.Lerp( Vector2.zero, vel, agent.remainingDistance / agent.stoppingDistance );
        } // 회전하는 로직

        //bool shouldMove = vel.magnitude > 0.5f
        //    && agent.remainingDistance > agent.stoppingDistance;

        //anim.SetBool("Move", shouldMove);
        anim.SetFloat("Wander", vel.magnitude);

        float deltaMagnitude = worldDeltaPosition.magnitude;
        if (deltaMagnitude > agent.radius / 2f)

        {
            transform.position = Vector3.Lerp(anim.rootPosition, agent.nextPosition, smooth);
        }
    }
    private void OnAnimatorMove()
    {
        Vector3 rootPosition = anim.rootPosition;
        rootPosition.y = agent.nextPosition.y;
        transform.position = rootPosition;
        agent.nextPosition = rootPosition;
    }


    void Update()
    {
        
    }
}
