using BearController;
using System;
using System.Collections;
using UnityEngine;
using UnityEngine.AI;
using State = Define.BearState;

public class Bear : Monster
{
    [SerializeField] private Transform eyes;
    [SerializeField] private Transform body;
    [SerializeField] private LayerMask groundLayer;

    [SerializeField] private AnimationCurve upwardCurve;
    [SerializeField] private AnimationCurve downwardCurve;

    [SerializeField] private Transform moveTarget;

    [HideInInspector] public float roarCooldown = 200.0f;
    [HideInInspector] public float roarCooldownDelta = 0.0f;

    [HideInInspector] public float attackCooldown = 3.0f;
    [HideInInspector] public float attackCooldownDelta = 0.0f;

    [HideInInspector] public State lastState;

    [SerializeField] private AudioClip roarClip;
    private NavMeshAgent agent;
    private AudioSource source;

    private int receivedDamage;
    
    public float decreaseVelocityRate = 0.0f;

    // 인스펙터 확인용
    public State state;

    public NavMeshAgent Agent => agent;
    public Transform Eyes => eyes;
    public Transform Body => body;
    public Transform MoveTarget => moveTarget;
    public AnimationCurve UpwardCurve => upwardCurve;
    public AnimationCurve DownwardCurve => downwardCurve;
    public LayerMask GroundLayer => groundLayer;
    public int ReceivedDamage => receivedDamage;


    public Action onKill;


    private void OnValidate()
    {
        if (agent == null)
        {
            agent = GetComponent<NavMeshAgent>();   
        }
        if (source == null)
        {
            source = GetComponent<AudioSource>();
        }
    }

    public override void Init()
    {
        base.Init();

        agent = GetComponent<NavMeshAgent>();
        agent.updateUpAxis = false;

        moveTarget = new GameObject("MoveTarget").transform;

        stateMachine.AddState(State.Idle, new IdleState(this));
        stateMachine.AddState(State.Think, new ThinkState(this));
        stateMachine.AddState(State.Trace, new TraceState(this));
        stateMachine.AddState(State.Rush, new RushState(this));
        stateMachine.AddState(State.Prowl, new ProwlState(this));
        stateMachine.AddState(State.Attack, new AttackState(this));
        stateMachine.AddState(State.Roar, new RoarState(this));
        stateMachine.AddState(State.Dead, new DeadState(this));
        
        stateMachine.InitState(State.Idle);
    }

    private void Update()
    {
        roarCooldownDelta -= Time.deltaTime;
        attackCooldownDelta -= Time.deltaTime;
    }

    private void OnEnable()
    {
        roarCooldownDelta = 0.0f;
        attackCooldownDelta = 0.0f;
    }

    public override void TakeDamage(ArrowData arrowData, AttackPointType attakcPointType)
    {
        if (currentStat.HealthPoint <= 0)
            return;

        // 데미지 공식
        receivedDamage = arrowData.ArrowTrueDamage + (arrowData.ArrowDamage - currentStat.Defence > 0
            ? arrowData.ArrowDamage - currentStat.Defence
            : 0);

        switch (attakcPointType)
        {
            case AttackPointType.Default:
                break;
            case AttackPointType.Legs:
                if (DecreasCoroutine != null)
                {
                    StopCoroutine(DecreasCoroutine);
                }
                DecreasCoroutine = StartCoroutine(DecreaseVelocityCoroutine());
                Debug.Log("LEGSHOT!");
                break;
            case AttackPointType.Head:
                int addDamage = (int)(receivedDamage * 0.25f);
                receivedDamage += addDamage;
                Debug.Log("HEADSHOT!");
                break;
        }

        currentStat.HealthPoint -= receivedDamage;

        if (currentStat.HealthPoint < 0.0f)
        {
            stateMachine.ChangeState(State.Dead);
        }
    }

    private void OnDrawGizmos()
    {
        if (agent.hasPath)
        {
            for (int i = 0; i < agent.path.corners.Length - 1; i++)
            {
                Debug.DrawLine(agent.path.corners[i], agent.path.corners[i + 1], Color.blue);
            }
        }
    }

    public void PlaySound(string clip)
    {
        source.PlayOneShot(roarClip, 0.7f);
    }

    public void StartBossFight()
    {
        target = Managers.Game.Player.transform;
        moveTarget.parent = target;
        moveTarget.SetLocalPositionAndRotation(Vector3.zero, Quaternion.identity);
    }

    private Coroutine DecreasCoroutine;

    private IEnumerator DecreaseVelocityCoroutine()
    {
        decreaseVelocityRate = 0.25f;
        yield return new WaitForSeconds(10.0f);
        decreaseVelocityRate = 0.0f;
    }
}